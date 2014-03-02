class ReportController < ApplicationController
  def index
  	@locations = Location.all
  end

  def show
  	@reports = Report.includes(:records).where(location_id: params[:location_id])
  end
end
