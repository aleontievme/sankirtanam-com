require 'net/pop'

class WelcomeController < ApplicationController
  def index
    @locations = Location.all
    @year      = DateTime.now.year
    @city_month_stat = StatisticLogic.locations_per_month.sort_by{|key,value| -value[-1] || 0}

  end
  
  def process_emails
    Net::POP3.disable_ssl()  
    Net::POP3.start('pop.locum.ru', 110, "sankirtanam@aleontiev.me","123") do |pop|  
      pop.each_mail { |mail| MailHandler.receive(mail.pop) }
    end
  end

end
