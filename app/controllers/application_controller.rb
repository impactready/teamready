class ApplicationController < ActionController::Base
  protect_from_forgery

  include UseSessionsHelper
  include GroupsHelper
  include UsersHelper

  helper_method :current_user
  helper_method :mobile_device?

  before_filter :check_access, :check_account_active, :check_payer, :prepare_for_mobile

  private

	def current_user
	  @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
	end


  def check_access
    deny_access unless signed_in?
  end

  def check_account_active
    deny_access_inactive unless current_user.account.active?
  end

  def check_payer
    if !current_user.account.payment_active && current_user.account.account_option.cost > 0
      if current_user.master_user
        redirect_to new_subscription_path
      else
        flash[:notice] = "Payment is not active for this account. Contact the master user for your team or organisation."
        sign_out
      end
    end
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param]
    else
      (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad|Tablet/)
    end
  end

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

end
