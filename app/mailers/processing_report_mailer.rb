class ProcessingReportMailer < ActionMailer::Base
  default from: "sankirtanam@aleontiev.me"

  def succesful(to)
    mail(to: to, subject: 'Ok')
  end

  def failed(to, reason)
  	@reason = reason
  	mail(to: to, subject: 'Failed')
  end
end
