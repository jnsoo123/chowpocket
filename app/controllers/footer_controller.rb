class FooterController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_if_user_has_phone_number

  def privacy
  end
  
  def faqs
  end
end
