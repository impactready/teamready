class AccountOptionsController < ApplicationController

  skip_before_filter :check_access, :check_account_active, :check_payer
  before_filter :only_admin_user

  def index
    @account_options = AccountOption.all
  end

  def new
   @account_option = AccountOption.new
  end

  def edit
   @account_option = AccountOption.find(params[:id])
  end

  def create
    @account_option = AccountOption.new(params[:account_option])
    if @account_option.save
      flash[:success] = "Account option updated."
      redirect_to account_options_path
    else
      render 'new'
    end
  end


  def update
    @account_option = AccountOption.find(params[:id])
    if @account_option.update_attributes(params[:account_option])
      flash[:success] = "Account option updated."
      redirect_to account_options_path
    else
      render 'edit'
    end
  end

  def destroy
    AccountOptions.find(params[:id]).destroy
    flash[:success] = "Account option removed."
    redirect_to account_options_path
  end

  private

  def only_admin_user
    deny_access_wrong_account unless current_user.admin_user == true
  end

end
