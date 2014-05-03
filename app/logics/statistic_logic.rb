class StatisticLogic
  # return statistic hash keyed by location for current year
  def self.locations_per_month
    result     = {}
    year_begin = DateTime.new(DateTime.now.year)
    reports    = Report.includes(:location,:records).where{date >= year_begin}
    months     = {-1=>0, 0=>0, 1=>0, 2=>0, 3=>0, 4=>0, 5=>0, 6=>0, 7=>0, 8=>0, 9=>0, 10=>0, 11=>0, 12=>0}
    
    # process each report for current year
    for report in reports 
      location  = report.location
      stat      = result[location]
      month     = report.date.month - 1

      # no stat found add to resulting hash
      if stat.nil? 
        result[location] = months.clone
        stat             = result[location]
      end

      # process each record in current report
      for record in report.records
      	q = quantity(record)
        stat[month] += q
        stat[-1]    += q
      end
    end

    result
  end


  def self.quantity(record)
    (record.mahabig || 0) + 
    (record.big     || 0) + 
    (record.medium  || 0) + 
    (record.small   || 0)
  end


end