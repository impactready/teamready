class MembershipsController < ApplicationController
  
  before_filter :check_master_user

  def create
    @membership = Membership.new(params[:membership])
    @membership.save
    assign_group
    respond_to do |format|
      format.html { redirect_to user_admin_groups_path(@membership.user)}
      format.js
    end
  end
  
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    assign_group
    respond_to do |format|
      format.html { redirect_to user_admin_groups_path(@membership.user)}
      format.js
    end
  end

  private

  def assign_group
    @account = current_user.account
    @groups = @account.groups.all
    @user = User.find(params[:membership][:user_id])
  end

  def check_master_user
    deny_access_master_user unless current_user.master_user?
  end

end