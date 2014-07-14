class PrioritiesController < ApplicationController

  before_filter :check_master_user

  def index
    @priorities = current_user.account.priorities
  end

  def new
    @account = current_user.account
    @priority = @account.priorities.new
  end

  def edit
    @account = current_user.account
    @priority = @account.priorities.find(params[:id])
  end

  def create
    if current_user.master_user?
    @account = current_user.account
    @priority = @account.priorities.build(params[:priority])
      if @priority.save
        flash[:success] = "Priority created."
        redirect_to priorities_path
      else
        flash[:error] = "Priority could not be created."
        render 'new'
      end
    else
      deny_access_master_user
    end
  end

  def update
    @account = current_user.account
    @priority = @account.priorities.find(params[:id])
    if @priority.update_attributes(params[:priority])
      flash[:success] = "Priority updated."
      redirect_to priorities_path
    else
      flash[:error] = "Priority could not be updated."
      render 'edit'
    end
  end

  def destroy
    priority = Priority.find(params[:id])
    priority.destroy
    redirect_to priorities_path
  end

  private

  def check_master_user
    deny_access_master_user unless current_user.master_user?
  end

end
