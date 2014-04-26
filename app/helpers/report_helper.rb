module ReportHelper
  def quantity(record)
    (record.mahabig || 0) + 
    (record.big     || 0) + 
    (record.medium  || 0) + 
    (record.small   || 0)
  end

  def points(record)
    (record.mahabig || 0) * 2 + 
    (record.big     || 0) * 1 + 
    (record.medium  || 0) * 0.5 + 
    (record.small   || 0) * 0.25
  end

  def summary(report)
    result = {mahabig:0, big:0, medium:0, small:0, journal:0, quantity:0, points:0}
    for record in report.records
      result[:mahabig] += record.mahabig || 0
      result[:big]     += record.big || 0
      result[:medium]  += record.medium || 0
      result[:small]   += record.small || 0
      result[:quantity]+= quantity(record) || 0
      result[:points]  += points(record) || 0
    end
    result
  end

  def records(report)
    report.records.sort_by{|x| points(x)}.reverse
  end
end
