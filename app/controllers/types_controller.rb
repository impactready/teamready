class TypesController < ApplicationController

  before_filter :check_master_user

  def index
    @types = current_user.account.types
  end

  def new
    @account = current_user.account
    @type = @account.types.new
  end

  def edit
    @account = current_user.account
    @type = @account.types.find(params[:id])
  end

  def create
    @account = current_user.account
    @type = @account.types.build(params[:type])
    if @type.save
      flash[:success] = "Type created."
      redirect_to types_path
    else
      flash[:error] = "Type could not be created."
      render 'new'
    end
  end

  def update
    @account = current_user.account
    @type = @account.types.find(params[:id])
    if @type.update_attributes(params[:type])
      flash[:success] = "Type updated."
      redirect_to types_path
    else
      flash[:error] = "Type could not be updated."
      render 'edit'
    end
  end

  def destroy
    type = Type.find(params[:id])
    type.destroy
    redirect_to types_path
  end

  private

  def check_master_user
    deny_access_master_user unless current_user.master_user?
  end

end
