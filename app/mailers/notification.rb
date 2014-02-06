class Notification < ActionMailer::Base
  default :from => "noreply@herokuapp.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification.notify_incivent.subject
  #
  def notify_incivent(user, group, incivent_url)
    @incivent_url = incivent_url
    @user = user
    @group = group
    mail(:to => @user.email, :subject => "[Incivent] - A new incivent has been created in the group '#{@group.name}' on the Incivent platform")
  end

  def notify_task(user, group, task_url)
    @task_url = task_url
    @group = group
    @user = user
    mail(:to => @user.email, :subject => "[Incivent] - #{@user.first_name}, a new action has been assigned to you in the group '#{@group.name}' on the Incivent platform")
  end

  def notify_message(user, group, message_url)
    @message_url  = message_url
    @group = group
    @user = user
    mail(:to => @user.email, :subject => "[Incivent] - #{@user.first_name}, a message has been created in the group '#{@group.name}' on the Incivent platform")
  end

  def notify_deadline(user, description )
    @description = description
    @user = user
    mail(:to => @user.email, :subject => "[Incivent] - #{user.first_name}, an action which has been assigned to you on the Incivent platform is now due")  
  end

  def notify_looming(user, description)
    @description = description
    @user = user
    mail(:to => @user.email, :subject => "[Incivent] - #{@user.first_name}, an action which has been assigned to you on the Incivent platform will be due in 4 days")  
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "[Incivent] - Password Reset"
  end

  def notify_contact(email, message)
    @email = email
    @message = message
    mail :to => "support@world-wize.com", :subject => "Query from Incivent.com"
  end

end
