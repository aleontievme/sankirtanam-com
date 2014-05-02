module WelcomeHelper
  def chart()
  	result     = {}
    year_start = DateTime.new(DateTime.now.year)
    reports    = Report.includes(:location, :records).where{date >= year_start}
    for report in reports
      location = report.location.short_name
      result[location] = 0 if result[location].nil?

      for record in report.records
        result[location] += quantity(record)
      end
    end

    result.sort_by {|key, value| -value} # and reverse to 
  end

  def quantity(record)
    (record.mahabig || 0) + 
    (record.big || 0) + 
    (record.medium || 0) + 
    (record.small || 0)
  end
end