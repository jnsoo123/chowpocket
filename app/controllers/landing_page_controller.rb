class LandingPageController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'landing'

  def index
    redirect_to building_path(current_user.building) if user_signed_in?
  end
end
