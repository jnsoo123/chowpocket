class CheckoutsController < ApplicationController
  def index
    redirect_to profiles_path, 
      notice: 'Please complete your profile information before you can order.' if current_user.incomplete_credentials?
  end
end
