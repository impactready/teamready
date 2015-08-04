class LaunchInterestsController < ApplicationController

  skip_before_filter :check_access, :check_account_active, :check_payer
  before_filter :only_admin_user, only: :index

  def index
    @launch_interests = LaunchInterest.all
  end

  def create
    @launch_interest = LaunchInterest.new(params[:launch_interest])
    if @launch_interest.save
      begin
        Notification.notify_contact(@launch_interest.email_address, @launch_interest.message, @launch_interest.subject).deliver_now
      rescue Exception => e
        logger.error "Unable to deliver the contact email: #{e.message}"
      end
      flash[:success] = "Thanks, your message has been received. We will contact you shortly."
      redirect_to root_path
    else
      flash[:error] = "There was a problem sending your message."
      redirect_to contact_path
    end
  end

  def destroy
    launch_interest = LaunchInterest.find(params[:id])
    launch_interest.destroy
    redirect_to launch_interests_path
  end

  private

  def only_admin_user
    deny_access_wrong_account unless (signed_in? && current_user.admin_user == true)
  end

end
