module UseSessionsHelper

#  def sign_in(user)
#    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
#    self.current_user = user
#  end

  def authenticate
    deny_access unless signed_in?
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def deny_access_master_user
    redirect_to root_path, :error => "You must be an administrator to access this page."
  end
  
  def deny_access_wrong_account
    redirect_to root_path, :error => "You are trying to access information from other users or accounts that you are not authorised to view."
  end

  def deny_access_inactive
    flash[:error] = "This account has been deactivated. Please contact support for more information."
    sign_out
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def current_user?(user)
    user == current_user
  end

  def sign_in(user) # The session variation of cookie use
    if params[:session][:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:auth_token)
    cookies.delete(:current_account_id) if cookies[:current_account_id]
    #reset_session
    redirect_to root_path
  end
 
#  def sign_out
#    cookies.delete(:remember_token)
#    self.current_user = nil
#  end

  private
  
  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end

end 