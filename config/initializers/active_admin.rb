ActiveAdmin.setup do |config|
  config.site_title = "Chowpocket"
  config.site_title_link = "/"
  config.authentication_method = :authenticate_admin!
  config.logout_link_path = :destroy_admin_user_session_path
  config.batch_actions = true
  config.localize_format = :long
  config.skip_before_action :check_if_user_has_phone_number
  config.register_stylesheet 'activeadmin_customizations.css'
end
