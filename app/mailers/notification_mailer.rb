class NotificationMailer < ActionMailer::Base

  default :from => APP_CONFIG['mail_from']
  default_url_options[:host] = APP_CONFIG['mail_url']
  
  
  def send_mail(prof, data)
    
    target = Prof.find(prof)
    email = target.user.email
    
    case data['action']
    when 'friendship'
      @profile1 = Prof.find(data['profile_id1'])
      @profile2 = Prof.find(data['profile_id2'])
      subject = t("activity.#{data['action']}.mail.subject", :profile1_name => @profile1.name) # profile2 name has accepted your friendship....
    end
    
    mail(:to => email, :subject => subject) do |format|
      format.text { render data['action'] }
      format.html { render data['action'], :layout => 'mail' }
    end
    
  end
  
end
