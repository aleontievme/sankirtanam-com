class ReportController < ApplicationController
  def index
  	@locations = Location.all
  end

  def show
    @year      = params[:year].to_i
    @month     = params[:month].to_i
    
    date_begin = DateTime.new(@year)
    date_end   = DateTime.new(@year, 12, 31)

    @location  = Location.find_by(permalink: params[:location]) 

  	@reports = Report.includes(:records)
  	  .where(location_id: @location.id)
  	  .where(:date => date_begin..date_end)
      .order(:date)
  end
end
