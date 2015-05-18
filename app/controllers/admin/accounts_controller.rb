class Admin::AccountsController < Admin::BaseController

  def index
    @accounts = Account.all
  end

  def edit
    @account = Account.find(params[:id])
  end

  def new
    if params[:account_option]
     @account = Account.new(account_option_id: AccountOption.find_by_name(params[:account_option]).id)
    else
      @account = Account.new
    end

    render '/accounts/new'
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      flash[:success] = "Account updated."
      redirect_to admin_accounts_path
    else
      render 'edit'
    end
  end

  def destroy
    account = Account.find(params[:id])
    account.active = false
    account.save!
    flash[:success] = "Your profile has been removed and your account closed. Payment profiles have cancelled."
    redirect_to accounts_path
  end
end