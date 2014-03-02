module ReportHelper
  def quantity(record)
    record.mahabig + 
    record.big + 
    record.medium + 
    record.small + 
    record.journal
  end

  def points(record)
    record.mahabig * 200 + 
    record.big     * 100 + 
    record.medium  * 50 + 
    record.small   * 25 + 
    record.journal * 20 	
  end

  def summary(report)
    result = {mahabig:0, big:0, medium:0, small:0, journal:0, quantity:0, points:0}
    for record in report.records
      result[:mahabig] += record.mahabig
      result[:big]     += record.big
      result[:medium]  += record.medium
      result[:small]   += record.small
      result[:journal] += record.journal
      result[:quantity]+= quantity(record)
      result[:points]  += points(record)
    end
    result
  end  
end
