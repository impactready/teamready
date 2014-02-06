class AdminGroupsController < ApplicationController
  
  def index
	@account = current_user.account
	@groups = @account.groups.all
	@user = @account.users.find(params[:user_id])
  end

end
