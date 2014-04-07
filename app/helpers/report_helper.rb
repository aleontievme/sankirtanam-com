module ReportHelper
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

  def points(record)
    record.mahabig * 200 + 
    record.big     * 100 + 
    record.medium  * 50 + 
    record.small   * 25
  end

  def summary(report)
    result = {mahabig:0, big:0, medium:0, small:0, journal:0, quantity:0, points:0}
    for record in report.records
      begin
        result[:mahabig] += record.mahabig
      rescue
      end
      
      begin
        result[:big]     += record.big
      rescue
      end
      
      begin
        result[:medium]  += record.medium
      rescue
      end
      
      begin
        result[:small]   += record.small
      rescue
      end
      
      begin
        result[:quantity]+= quantity(record)
      rescue
      end
      
      begin
        result[:points]  += points(record)
    enrescue
  end
  
    d
    result
  end

  def records(report)
    report.records.sort_by{|x| points(x)}.reverse
  end
end
