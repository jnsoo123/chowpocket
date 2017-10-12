class ProfilesController < ApplicationController
  skip_before_action :check_if_user_has_phone_number

  def show
  end 

  def edit
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profiles_url, notice: 'Profile has been updated.'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :phone_number, :company_name, :floor, :building_id)
  end
end
