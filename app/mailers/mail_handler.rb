class MailHandler < ActionMailer::Base
  def receive(email)
    puts "========== #{email.body.to_s.nil?}"
    return if email.body.to_s.nil?
    #puts "!!!! #{email.body.to_s.split(/\r?\n/)}"
    email.body.to_s.split(/\r?\n/).each { |line|
      puts "!!!!!!!! #{line}"
      #name = line.split(":")[0]
      #if !name.nil?
      #  values = line.split(":")[1].split(",")
      #  puts "#{name}: #{values[0]} #{values[1]} #{values[2]} #{values[3]} #{values[4]}"   
      #end 
    }
    # here you will have an email object and will be able to call methods like
    # email.subject and email.attachments
    # puts "from: #{email.from}, subject: '#{email.subject}', body: '#{email.body}'"
  end
end