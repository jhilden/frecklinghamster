class FactsController < ApplicationController
  def week
    @week_nr = (params[:week_nr] || Date.today.cweek).to_i
    @year = (params[:year] || Date.today.year).to_i
    date = Date.commercial(@year, @week_nr)
    @week_start = date.beginning_of_week
    @week_end = date.end_of_week

    @facts = Fact.where("start_time > ?", @week_start).where("start_time < ?", @week_end).order(:start_time)
  end

  def export
    require 'net/http'
    require 'net/https'

    fact = Fact.find params[:id]

    unless Freckle::PROJECT_MAPPING[fact.activity_id]
      redirect_to(:back, error: "ERROR: No mapping for project") and return
    end

    body = {
      "entry" => {
        "minutes" => fact.duration_in_minutes,
        "user" => Freckle::USER,
        "project_id" => Freckle::PROJECT_MAPPING[fact.activity_id],
        "description" => fact.description,
        "date" => l(fact.start_time.to_date, format: :default)
      }
    }.to_json

    puts body.inspect

    header = {
      'Content-Type' => 'application/json',
      'X-FreckleToken' => Freckle::API_TOKEN
    }

    uri = URI.parse("https://#{Freckle::DOMAIN}/api/entries.json")
    puts uri
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, initheader = header)
    request.body = body
    response = https.request(request)

    if response.code == 200
      flash[:succes] = "Successfully exported"
    else
      flahs[:error] = "ERROR exporting: Response #{response.code} #{response.message}: #{response.body}"
    end

    redirect_to :back
  end
end
