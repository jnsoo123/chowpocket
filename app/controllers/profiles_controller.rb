class ProfilesController < ApplicationController
  skip_before_action :check_if_user_has_phone_number

  def show
  end 

  def edit
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to profiles_url, notice: 'Profile has been updated.'
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :phone_number)
  end
end
