class UseSessionsController < ApplicationController

  skip_before_filter :check_access, :check_account_active, :check_payer

  def new
  end

  def create
    user = User.authenticate(params[:session][:email].strip.downcase, params[:session][:password].strip)
    if user
      sign_in user
      flash[:success] = "Login successful!"
      mobile_device? ? redirect_back_or(tasks_path) : redirect_back_or(groups_path)
    else
      flash[:error] = "Invalid username or password."
      render 'new'
    end
  end

  def destroy
    sign_out
  end

end
