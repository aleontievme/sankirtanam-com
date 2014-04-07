# ecoding: utf-8

require 'iconv'
require 'digest/sha1'
require 'rubygems'
require 'roo'

class MailHandler < ActionMailer::Base

  def open_spreadsheet(file)
    tempfile = File.new("#{Rails.root.to_s}/tmp/#{file.filename}", "w+")
    tempfile << file.decoded.to_s.force_encoding("UTF-8")
    tempfile.flush

    case File.extname(file.filename)
    when '.csv' then Csv.new(tempfile.path, nil, :ignore)
    when '.xls' then Excel.new(tempfile.path, nil, :ignore)
    when '.xlsx' then Excelx.new(tempfile.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end  


  def receive(email)
    permalink = Digest::SHA1.hexdigest (email.from.to_s+email.date.to_s)
    location  = Location.find_by_email(email.from)

    # check for errors

    if location == nil
      ProcessingReportMailer.failed(email.from, 'Location not found').deliver
      return
    end

    if Report.find_by_permalink(permalink)
      #return
    end

    if email.subject.nil?
      ProcessingReportMailer.failed(email.from, 'No data set in subject. Use dd/mm/yyyy format').deliver
      return
    end

    begin
      date = Date.strptime(email.subject, "%d/%m/%Y")
      if date.nil?
        ProcessingReportMailer.failed(email.from, 'Wrong date in subject. Use dd/mm/yyyy format').deliver
        return
      end
    rescue
      ProcessingReportMailer.failed(email.from, 'Wrong date in subject. Use dd/mm/yyyy format').deliver
      return
    end

    # process attachments

    email.attachments.each{ |file|
      report = Report.new
      report.permalink = permalink
      report.date      = date #todo
      report.location  = location
      report.save

      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        record = Record.new()
        record.distributor = row["name"]
        record.mahabig = row["mahabig"]
        record.big = row["big"]
        record.medium = row["medium"]
        record.small = row["small"]
        report.records << record
        record.save
      end
    }

    return 


    #return if email.body.to_s.nil?
    #body = email.body.to_s.force_encoding("UTF-8") # encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '??')

    #if not body.valid_encoding?
    #  ProcessingReportMailer.failed(email.from).deliver
    #  return
    #end
    #permalink = Digest::SHA1.hexdigest (email.from.to_s+email.date.to_s)
    #location  = Location.find_by_email(email.from)
    #date      = DateTime.now

    

    
    #return if Report.find_by_permalink(permalink)

    #report = Report.new
    #report.permalink = permalink
    #report.date      = date #todo
    #report.location  = location
    #report.save


    body.to_s.split(/\r?\n/).each { |line|
      name = line.split(":")[0]
      if !name.nil?
        values = line.split(":")[1]
        name   = name

        if values
          q = values.split(",")
          #puts "++++ #{name}: mahabig:#{q[0]} big:#{q[1]} medium:#{q[2]} small:#{q[3]} journals:#{q[4]}"
          record = Record.new()
          record.distributor = name.force_encoding("UTF-8")
          record.mahabig = q[0].strip
          record.big = q[1].strip
          record.medium = q[2].strip
          record.small = q[3].strip
          #record.journal = q[4].strip
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