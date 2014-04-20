# ecoding: utf-8

require 'iconv'
require 'digest/sha1'
require 'rubygems'
require 'roo'

class MailHandler < ActionMailer::Base
  
  def receive(email)
    permalink = Digest::SHA1.hexdigest (email.from.to_s + email.date.to_s)
    subject   = email.subject

    # email already processed
    if Report.find_by_permalink(permalink) then return end

    # check for errors
    begin
      date     = find_date(email)
      location = find_location(email)

      if location == nil then raise "Location not found" end
      if date == nil then raise "Date not set" end

      process_email(email, permalink, date, location)
      ProcessingReportMailer.succesful(email.from).deliver
    rescue RuntimeError => ex
      ProcessingReportMailer.failed(email.from, "#{ex.message}").deliver
    end
  end



  def find_date(email)
    subject = email.subject
    date_token = subject.split(" ")[0]
    Date.strptime(date_token, "%d/%m/%Y")
  end

  def find_location(email)
    subject = email.subject
    location_token = subject.split(" ")[1]
    Location.find_by_name(location_token)
  end

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

  def process_email(email, permalink, date, location)
    email.attachments.each{ |file|
      report = Report.new
      report.permalink = permalink
      report.date      = date
      report.location  = location
      report.save

      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        record = Record.new()
        record.distributor = row["name"] || row["имя"]
        record.mahabig = row["mahabig"] || row["Махабиги"]
        record.big = row["big"] || row["Большие"]
        record.medium = row["medium"] || row["Средние"]
        record.small = row["small"] || row["Малые"]
        report.records << record
        record.save
      end
    }
  end  

end