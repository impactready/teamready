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
    mail(:to => @user.email, :subject => "[ImpactReady] - A new event has been created in the group '#{@group.name}' on ImpactReady")
  end

  def notify_task(user, group, task_url)
    @task_url = task_url
    @group = group
    @user = user
    mail(:to => @user.email, :subject => "[ImpactReady] - #{@user.first_name}, a new action has been assigned to you in the group '#{@group.name}' on ImpactReady")
  end

  def notify_message(user, group, message_url)
    @message_url  = message_url
    @group = group
    @user = user
    mail(:to => @user.email, :subject => "[ImpactReady] - #{@user.first_name}, a message has been created in the group '#{@group.name}' on ImpactReady")
  end

  def notify_deadline(user, description )
    @description = description
    @user = user
    mail(:to => @user.email, :subject => "[ImpactReady] - #{user.first_name}, an action which has been assigned to you on ImpactReady is now due")
  end

  def notify_looming(user, description)
    @description = description
    @user = user
    mail(:to => @user.email, :subject => "[ImpactReady] - #{@user.first_name}, an action which has been assigned to you on ImpactReady will be due in 4 days")
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "[ImpactReady] - Password Reset"
  end

  def notify_contact(email, message, subject)
    @email = email
    @message = message
    mail :to => ["joseph@impactready.org", "raouldevilliers@gmail.com"], :subject => "Query from ImpactReady.com"
  end

end
