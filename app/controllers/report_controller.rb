class ReportController < ApplicationController
  def index
  	@locations = Location.all
  end

  def show
  	@report = Report.find_by_location_id(params[:location_id])
  end
end
