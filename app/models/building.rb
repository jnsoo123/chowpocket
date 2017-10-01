class Building < ApplicationRecord
  has_many :users, dependent: :nullify

  before_destroy do
    self.users.update_all company_name: nil, floor: nil 
  end
end
