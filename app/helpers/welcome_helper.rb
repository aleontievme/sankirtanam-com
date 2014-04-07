module WelcomeHelper
  def chart()
  	result  = {0 => 0}
    records = Record.joins{report}
    for record in records
      month = record.report.date.month
      cur   = result[month]
      result[month] = 0 if cur.nil?
      result[month] += quantity(record)
    end
    result
  end

  def quantity(record)
    begin
      record.mahabig + 
      record.big + 
      record.medium + 
      record.small
    rescue
      0
    end
  end
end