module Util

  # Creates and queues an email message
  # - to: Comma separated values for multiple emails
  # - from: Caller has to determin the sender
  # - message: Is the finnal message to be sent, may be HTML
  # - send_at: Datetime Email will not be sent before this date. If parameter is nil then it indicates email should be sent ASAP
  def self.queue_mail (to, from, subject, message, send_at = nil)
    EmailQueue.create(:to=>to, :from=>from, :subject=>subject, :message=>message, :send_at=>send_at)
  end    
  
  #Determins if a string represents the value for true
  # - str: Result is true IIF str=="true"
  def self.to_boolean(str)
    str == 'true' ? true : false
  end
  
  #Gets the number representing the week day
  def self.to_week_day_i(str)
    ret = -1
    str = str.downcase
    if str == "Monday"
      ret = 1
    elsif str == "Tuesday"
      ret = 2
    elsif str == "Wednesday"
      ret = 3
    elsif str == "Thursday"
      ret = 4
    elsif str == "Friday"
      ret = 5
    elsif str == "Saturday"
      ret = 6
    elsif str == "Sunday"
      ret = 7
    end
    ret
  end
  
  #Gets the string representing the week day integer
  def self.to_week_day_str(i)
    ret = "Undefined"
    if i == 1
      ret = "Monday"
    elsif i == 2
      ret = "Tuesday"
    elsif i == 3
      ret = "Wednesday"
    elsif i == 4
      ret = "Thursday"
    elsif i == 5
      ret = "Friday"
    elsif i == 6
      ret = "Saturday"
    elsif i == 7
      ret = "Sunday"
    end
    ret
  end
  
  #Gets the integer representing the text for send via
  def self.to_send_via_i(str)
    ret = 1
    if str.downcase.include? "email"
      ret = 1
    elsif str.downcase.include?  "text"
      ret = 0
    elsif str.downcase.include?  "both"
      ret = 2      
    end
    ret
  end
  

end
