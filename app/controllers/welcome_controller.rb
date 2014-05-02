require 'net/pop'

class WelcomeController < ApplicationController
  def index
    @locations = Location.all
    @year      = DateTime.now.year

    city_month_stat = {}
    year_start      = DateTime.new(DateTime.now.year)
    reports         = Report.includes(:location,:records).where{date >= year_start}
    for report in reports
      location                  = report.location
      city_month_stat[location] = {0=>0,1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0,12=>0} if city_month_stat[location].nil?
      cur_stat                  = city_month_stat[location]

      for record in report.records
        cur_stat[report.date.month-1] += quantity(record)
      end
    end

    #city_month_stat.sort_by {|key, value| -value} # and reverse to 
    @city_month_stat = city_month_stat
  end

  def quantity(record)
    (record.mahabig || 0) + 
    (record.big || 0) + 
    (record.medium || 0) + 
    (record.small || 0)
  end
  
  def process_emails
    Net::POP3.disable_ssl()  
    Net::POP3.start('pop.locum.ru', 110, "sankirtanam@aleontiev.me","123") do |pop|  
      pop.each_mail { |mail| MailHandler.receive(mail.pop) }
    end
  end

end
