class CheckoutsController < ApplicationController
  def index
    current_user.update unionbank_code: params[:code] if params[:code].present?

    redirect_to profiles_path, 
      notice: 'Please complete your profile information before you can order.' if current_user.incomplete_credentials?
  end
end
