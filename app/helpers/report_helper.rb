module ReportHelper
  def quantity(record)
    record.mahabig + 
    record.big + 
    record.medium + 
    record.small
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
      result[:mahabig] += record.mahabig
      result[:big]     += record.big
      result[:medium]  += record.medium
      result[:small]   += record.small
      result[:quantity]+= quantity(record)
      result[:points]  += points(record)
    end
    result
  end

  def records(report)
    report.records.sort_by{|x| points(x)}.reverse
  end
end
