class AccountInvite < ActionMailer::Base
  default :from => "noreply@incivent.com"

  def invitation (invitation, signup_url)
    @signup_url = signup_url
    @account = Account.find(invitation.account_id)
    mail(:to => invitation.recipient_email, :subject => "[ImpactReady] - Invitation to register")
  end
end
