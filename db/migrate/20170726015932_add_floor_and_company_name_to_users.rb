class AddFloorAndCompanyNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :floor, :integer
    add_column :users, :company_name, :string
  end
end
