class StatusesController < ApplicationController

  before_filter :check_master_user

  def index
    @statuses = current_user.account.statuses
  end

  def new
    @account = current_user.account
    @status = @account.statuses.new
  end

  def edit
    @account = current_user.account
    @status = @account.statuses.find(params[:id])
  end

  def create
    @account = current_user.account
    @status = @account.statuses.build(params[:status])
    if @status.save
      flash[:success] = "Status created."
      redirect_to statuses_path
    else
      flash[:error] = "Status could not be created"
      render 'new'
    end
  end

  def update
    @account = current_user.account
    @status = @account.statuses.find(params[:id])
    if @status.update_attributes(params[:status])
      flash[:success] = "Status updated."
      redirect_to statuses_path
    else
      flash[:error] = "Status could not be updated."
      render 'edit'
    end
  end

  def destroy
    status = Status.find(params[:id])
    status.destroy
    redirect_to statuses_path
  end

  private

  def check_master_user
    deny_access_master_user unless current_user.master_user?
  end

end
