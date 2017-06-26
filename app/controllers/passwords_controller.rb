class PasswordsController < ApplicationController
  def edit
  end

  def update
    @user = current_user
    if @user.update_with_password(user_params)
      bypass_sign_in @user
      redirect_to profiles_url, notice: 'Password has been changed.'
    else
      flash[:error] = @user.errors.full_messages.to_sentence.capitalize
      render :edit
    end

  end

  private
  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
