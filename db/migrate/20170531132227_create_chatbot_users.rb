class CreateChatbotUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :chatbot_users do |t|
      t.string :name
      t.string :contact_number
      t.string :state

      t.timestamps
    end
  end
end
