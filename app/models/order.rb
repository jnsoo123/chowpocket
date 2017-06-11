class Order < ApplicationRecord
  belongs_to :cart

  after_create do
    cart.update is_ordered: true
  end
end
