class FooterController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_if_user_has_phone_number
  skip_before_action :set_cart

  def privacy
  end
  
  def faqs
  end

  def contact_us
  end
end
