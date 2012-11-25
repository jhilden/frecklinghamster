class FactsController < ApplicationController

  before_filter :load_fact, only: [:mark_as_exported, :export]

  def week
    @week_nr = (params[:week_nr] || Date.today.cweek).to_i
    @year = (params[:year] || Date.today.year).to_i
    date = Date.commercial(@year, @week_nr)
    @week_start = date.beginning_of_week
    @week_end = date.end_of_week

    @facts = Fact.where("start_time > ?", @week_start).where("start_time < ?", @week_end).order(:start_time)
  end

  def batch_export
    unless @facts = Fact.find(params[:fact_ids])
      redirect_to(:back, error: "ERROR loading facts") and return
    end

    if @facts.any?{|f| f.exported? }
      redirect_to(:back, error: "ERROR: One of the facts is already exported") and return
    end

    unless project_id = Freckle::PROJECT_MAPPING[@facts.first.activity_id]
      redirect_to(:back, error: "ERROR: No mapping for project") and return
    end

    body = {
      "entry" => {
        "minutes" => @facts.inject(0) {|sum, f| sum + f.duration_in_minutes },
        "user" => Freckle::USER,
        "project_id" => project_id,
        "description" => @facts.first.freckle_tags_description_string,
        "date" => l(@facts.first.start_time.to_date, format: :default)
      }
    }.to_json

    response = export_to_freckle(body)

    if response.code == "201"
      @facts.each do |fact|
        fact.exported_at = Time.now
        unless fact.save
          flash[:error] = "Successfully exported, but problem marking fact #{fact.id} as exported"
        end
      end

      unless flash[:error]
        flash[:succes] = "Successfully exported"
      end
    else
      flash[:error] = "ERROR exporting: Response #{response.code} #{response.message}: #{response.body}"
    end

    redirect_to :back
  end

  # /facts/x/export
  def export
    if @fact.exported?
      redirect_to(:back, error: "ERROR: Already exported") and return
    end

    unless project_id = Freckle::PROJECT_MAPPING[@fact.activity_id]
      redirect_to(:back, error: "ERROR: No mapping for project") and return
    end

    body = {
      "entry" => {
        "minutes" => @fact.duration_in_minutes,
        "user" => Freckle::USER,
        "project_id" => project_id,
        "description" => @fact.freckle_tags_description_string,
        "date" => l(@fact.start_time.to_date, format: :default)
      }
    }.to_json

    response = export_to_freckle(body)

    if response.code == "201"
      @fact.exported_at = Time.now
      if @fact.save
        flash[:success] = "Successfully exported"
      else
        flash[:error] = "Exported successfully, but error marking as exported"
      end
    else
      flash[:error] = "ERROR exporting: Response #{response.code} #{response.message}: #{response.body}"
    end

    redirect_to :back
  end

  def mark_as_exported
    @fact.exported_at = Time.now
    if @fact.save
      flash[:success] = "Fact #{@fact.id} successfully marked as exported"
    else
      flash[:error] = "ERROR marking fact as exported"
    end
    redirect_to :back
  end

  private
    def load_fact
      unless @fact = Fact.find(params[:id])
        redirect_to :back, error: "ERROR loading fact"
      end
    end

    def export_to_freckle(body)
      require 'net/http'
      require 'net/https'

      header = {
        'Content-Type' => 'application/json',
        'X-FreckleToken' => Freckle::API_TOKEN
      }

      uri = URI.parse("https://#{Freckle::DOMAIN}/api/entries.json")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, initheader = header)
      request.body = body
      response = https.request(request)
    end
end
