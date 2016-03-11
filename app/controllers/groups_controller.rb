class GroupsController < ApplicationController

  before_filter :check_account, only: [:new, :create, :update, :edit, :destroy]
  before_filter :check_master_user, only: [:new, :create, :update, :edit, :destroy]
  #before_filter :check_group_number, only: :new

  def index
    if current_user.master_user?
      @groups = current_user.account.groups
    else
      @groups = current_user.groups
    end
    @ids_for_earth = []
    @groups.each { |group| @ids_for_earth << group.id unless group.incivents.unarchived.count == 0 && group.tasks.unarchived.count == 0 && group.stories.unarchived.count == 0 && group.measurements.unarchived.count == 0 }
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @account = current_user.account
    @group = @account.groups.build(params[:group])
    if @group.save
      @membership = current_user.memberships.build(group_id: @group.id)
      if @membership.save
        flash[:success] = "Team created."
        redirect_to groups_path
      else
        group_save_unsuccessful
      end
    else
      group_save_unsuccessful
    end
  end

  def update
    @account = current_user.account
    @group = @account.groups.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:success] = "Team updated."
      redirect_to groups_path
    else
      flash[:error] = "The team could not be updated."
      render 'edit'
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    flash[:success] = "Team removed."
    redirect_to groups_path
  end

  def check_group_number
    unless current_user.account.account_option.groups > current_user.account.groups.count
      flash[:error] = "You have reached the maximum number of teams for your account option. Please upgrade."
      if current_user.master_user?
        redirect_to account_path(current_user.account)
      else
        redirect_to root_path
      end
    end
  end

  private

  def check_account
    deny_access_wrong_account unless current_user.account.users.find(current_user.id)
  end

  def check_master_user
    deny_access_master_user unless current_user.master_user?
  end

end
