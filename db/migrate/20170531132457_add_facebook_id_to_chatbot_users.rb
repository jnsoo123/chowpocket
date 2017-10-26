class AddFacebookIdToChatbotUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :chatbot_users, :facebook_id, :string
  end
end
