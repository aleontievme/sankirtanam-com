require 'digest/sha1'

class MailHandler < ActionMailer::Base
  def receive(email)
    return if email.body.to_s.nil?
    body = email.body.to_s.force_encoding("UTF-8") # encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '??')

    if not body.valid_encoding?
      ProcessingReportMailer.failed(email.from).deliver
      return
    end

    permalink = Digest::SHA1.hexdigest (email.from.to_s+email.date.to_s)
    location = Location.find_by_email(email.from)
    date = DateTime.now

    return if Report.find_by_permalink(permalink)

    report = Report.new
    report.permalink = permalink
    report.date = date #todo
    report.location = location
    report.save


    body.to_s.split(/\r?\n/).each { |line|
      name = line.split(":")[0]
      if !name.nil?
        values = line.split(":")[1]
        name = name

        if values
          q = values.split(",")
          puts "++++ #{name}: mahabig:#{q[0]} big:#{q[1]} medium:#{q[2]} small:#{q[3]} journals:#{q[4]}"
          record = Record.new()
          record.distributor = name.force_encoding("UTF-8")
          record.mahabig = q[0].strip
          record.big = q[1].strip
          record.medium = q[2].strip
          record.small = q[3].strip
          record.journal = q[4].strip
          report.records << record
          record.save
        end  
      end 
    }

    ProcessingReportMailer.succesfully_processed(email.from).deliver
    
    # here you will have an email object and will be able to call methods like
    # email.subject and email.attachments
    # puts "from: #{email.from}, subject: '#{email.subject}', body: '#{email.body}'"
  end
end