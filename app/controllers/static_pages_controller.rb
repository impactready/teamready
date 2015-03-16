class StaticPagesController < ApplicationController
  layout :determine_home

  skip_before_filter :check_access, :check_account_active, :check_payer

  def home
    if mobile_device?
      current_user ? redirect_to(tasks_path) : redirect_to(signin_path)
    else
      redirect_to groups_path if current_user
    end
  end

  def offering
  end

  def about
  end

  def contact
    @launch_interest = LaunchInterest.new
    @new_account = params[:new_account] ? true : false
  end

  def privacy
  end

  def service_terms
  end

  private

  def determine_home
    if action_name == 'home'
      'frontpage'
    else
      'application'
    end
  end

end
