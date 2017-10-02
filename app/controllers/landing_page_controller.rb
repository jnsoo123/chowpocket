class LandingPageController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'landing'

  def index
    if user_signed_in? && current_user.building.present?
      redirect_to buildings_path 
    end
  end
end
