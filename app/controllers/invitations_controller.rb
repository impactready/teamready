class InvitationsController < ApplicationController
  
  skip_before_filter :check_access, :check_account_active, :check_payer
  before_filter :check_user_number, :only => :new

  def new
    if signed_in?
      if current_user.master_user?
        @invitation = Invitation.new(:account_id => current_user.account.id)
      else
        flash[:notice] = "Invites can only be sent by the account master user."
        redirect_to root_path
      end
    else
      # This is for completely new signups, i.e. not done by the admin user.
      if cookies[:current_account_id]
        @account = Account.find(cookies[:current_account_id])
        if @account.users.count == 0
          @new_account = true
          @invitation = Invitation.new(:account_id => @account.id)
        else
          deny_access
        end
      else
        deny_access
      end
    end
  end

  def create
    @invitation = Invitation.new(params[:invitation])
    if @invitation.save
      # Signup_path/signup_url is defined in the routes.rb file.
      AccountInvite.invitation(@invitation, signup_url + "/" + @invitation.token).deliver rescue logger.error 'Unable to deliver the invitation email.'
      flash[:notice] = "Further registation steps have been sent to the email address."
      if signed_in?
        redirect_to current_user.account
      else
        redirect_to root_path
      end
      cookies.delete(:current_account_id)   
    else
      render :action => 'new'
    end
  end

  def check_user_number
    if signed_in?
      unless current_user.account.account_option.users > current_user.account.users.count
        flash[:error] = "You have reached the maximum number of users for your account option. Please upgrade."
        if current_user.master_user?
          redirect_to current_user.account
        else
          redirect_to root_path
        end
      end
    end
  end
end