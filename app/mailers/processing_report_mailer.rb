class ProcessingReportMailer < ActionMailer::Base
  default from: "sankirtanam@aleontiev.me"

  def succesfully_processed(to)
    mail(to: to, subject: 'Ok')
  end

  def failed(to)
  	mail(to: to, subject: 'Failed')
  end
end
