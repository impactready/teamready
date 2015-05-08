class UsersController < ApplicationController

  skip_before_filter :check_access, :check_account_active, :check_payer, only: [:new, :create]

  def index
    if current_user.master_user?
      @users = current_user.account.users
    else
      @users = current_user.relevant_members
    end
  end

  def new
    if signed_in?
      flash[:error] = "You are already an existing user."
      redirect_to root_path
    else
      @user = User.new
      if params[:invitation_token]
        @invitation = Invitation.find_by_token(params[:invitation_token])
        @user.email = @invitation.recipient_email.downcase
        cookies[:current_account_id] = @invitation.account_id
      else
        flash[:error] = "You need to access this page from an invitation email sent to you."
        redirect_to root_path
      end
    end
  end

  def edit
    @account = current_user.account
    if current_user.master_user?
      @user = @account.users.find(params[:id])
    else
      @user = current_user
    end
  end

  def create
    @account = Account.find(cookies[:current_account_id])
    @user = @account.users.build(params[:user])
    if @account.users.count == 0
      @user.toggle(:master_user)
      @account.active = true
    end
    if @user.save
      cookies[:auth_token] = @user.auth_token # Sign in the user
      cookies.delete(:current_account_id)
      flash[:success] = "You have now been registered."
      redirect_to groups_path
    else
      @user.password = nil
      @user.password_confirmation = nil
      render 'new'
    end
  end


  def update
    @account = current_user.account
    @user = @account.users.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to groups_path
    else
      flash[:error] = "There was a problem updating your profile."
      render 'edit'
    end
  end

  def destroy
    if current_user.master_user?
      account = current_user.account
      user = account.users.find(params[:id])
      if current_user == user
        flash[:error] = "You cannot remove yourself."
      else
        user.destroy
        flash[:success] = "User removed."
      end
    else
      flash[:error] = "Only a master user can destroy users."
    end
    redirect_to users_path
  end


end
