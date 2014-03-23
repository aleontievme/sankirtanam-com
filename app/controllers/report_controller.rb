class ReportController < ApplicationController
  def index
  	@locations = Location.all
  end

  def show
    date_start = Time.strptime(params[:date_start], "%m/%d/%Y")
    date_end   = Time.strptime(params[:date_end], "%m/%d/%Y")

  	@reports = Report.includes(:records)
  	  .where(location_id: params[:location_id])
  	  .where(:date => date_start..date_end)
      .order(:date)
  end
end
