class ExportsController < ApplicationController
  def week
    @week_nr = (params[:week_nr] || Date.today.cweek).to_i
    @year = (params[:year] || Date.today.year).to_i
    date = Date.commercial(@year, @week_nr)
    @week_start = date.beginning_of_week
    @week_end = date.end_of_week

    @facts = Fact.where("start_time > ?", @week_start).where("start_time < ?", @week_end)
  end
end
