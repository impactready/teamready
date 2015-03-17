class PasswordResetsController < ApplicationController

	skip_before_filter :check_access, :check_account_active, :check_payer

	def create
	  user = User.find_by_email(params[:p_reset][:email])
	  user.send_password_reset if user
	  flash[:success] = "Email sent with password reset instructions."
	  redirect_to root_url
	end

	def edit
	  @user = User.find_by_password_reset_token!(params[:id])
	end

	def update
	  @user = User.find_by_password_reset_token!(params[:id])
	  if @user.password_reset_sent_at < 2.hours.ago
	  	flash[:error] = "Password reset has expired."
	    redirect_to new_password_reset_path
	  elsif @user.update_attributes(params[:user])
	  	flash[:success] = "Password has been reset!"
	    redirect_to root_url
	  else
	    render :edit
	  end
	end

end
