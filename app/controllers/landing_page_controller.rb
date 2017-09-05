class LandingPageController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'landing'

  def index
    if user_signed_in? && current_user.building.present?
      redirect_to building_path(current_user.building) 
    end
  end
end
