Admin::UsersController < Admin::BaseController

  def destroy
    user = Users.find(params[:id])
    if current_user == user
      flash[:error] = "You cannot remove yourself."
    else
      user.destroy
      flash[:success] = "User removed."
    end
  end
end