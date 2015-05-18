class Admin::BaseController < ApplicationController

  before_filter :check_admin_user

  private

  def check_admin_user
    deny_access unless current_user.admin_user?
  end

end
