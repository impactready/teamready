class AccountsController < ApplicationController

  skip_before_filter :check_access, :check_account_active , :only => [:new, :create]
  skip_before_filter :check_payer, :only => [:new, :create, :destroy]


  def index
    if signed_in? && current_user.god_user?
      @accounts = Account.all
    else
      deny_access
    end
  end

  def show
    if signed_in? && current_user.master_user?
      @account = current_user.account
    else
      deny_access
    end
  end

  def new
    if signed_in?
      flash[:error] = "You already have an account."
      redirect_to root_path
    else
      if params[:account_option]
       @account = Account.new(:account_option_id => AccountOption.find_by_name(params[:account_option]).id)
      else
        @account = Account.new
      end
    end
  end

  def edit
    if signed_in? && current_user.master_user?
      @account = current_user.account
    elsif current_user.god_user
      @account = Account.find(params[:id])
    else
      deny_access
    end
  end

  def create
    @account = Account.new(params[:account])
    @account.toggle(:active)
    if @account.save
      AccountInterface.set_account_defaults(@account)
      cookies[:current_account_id] = @account.id
      flash[:success] = "Your account has been created."
      redirect_to new_invitation_path
    else
      render 'new'
    end
  end


  def update
    @account = Account.find(params[:id])
    # change_account = false
    # if @account.account_option != AccountOption.find(params[:account][:account_option_id])
    #   change_account = true
    # end
    if @account.update_attributes(params[:account])
      # if change_account == true
      #   @subscription = @account.subscription
      #   response = @subscription.update_pp_recurring(@account).update_recurring_profile
      #   Subscription.check_paypal_response(response)
      # end
      flash[:success] = "Account updated."
      if current_user.god_user
        redirect_to accounts_path
      else
        redirect_to @account
      end
    else
      render 'edit'
    end
  end

  def destroy
    account = Account.find(params[:id])
    if account.account_option.cost > 0 && @account.payment_active?
      account.subscription.cancel_pp_subscription
      Subscription.check_paypal_response(response)
      account.payment_active = false
    end
    account.active = false
    account.save!
    flash[:success] = "Your profile has been removed and your account closed. Payment profiles have cancelled."
    if current_user.god_user?
      redirect_to accounts_path
    else
      sign_out
    end
  end

end
