class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    current_user.update(users_params)
    redirect_to comments_path
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
