class ProfilesController < ApplicationController
  skip_before_action :check_if_user_has_phone_number

  def show
  end 

  def edit
  end

  def verify
    number = params[:number]
    api = SemaphoreApi.new
    api.send_number_verification_message(number, current_user)
  end

  def update
    @user = current_user

    if verify_number
      if @user.update(user_params)
        redirect_to profiles_url, notice: 'Profile has been updated.'
      else
        flash[:error] = @user.errors.full_messages.to_sentence
        render :edit
      end
    else
      flash[:error] = 'Invalid verification code.'
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :phone_number, :company_name, :floor, :building_id)
  end
  
  def verify_number
    verification_code = params[:verification_code]
    @user.authenticate_otp(verification_code, drift: 60)
  end
end
