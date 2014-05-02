module WelcomeHelper
  def chart()
  	result  = {}
    records = Record.joins{report}
    for record in records
      location = record.report.location.short_name
      cur   = result[location]
      result[location] = 0 if cur.nil?
      result[location] += quantity(record)
    end
    result
  end

  def quantity(record)
    (record.mahabig || 0) + 
    (record.big || 0) + 
    (record.medium || 0) + 
    (record.small || 0)
  end
end