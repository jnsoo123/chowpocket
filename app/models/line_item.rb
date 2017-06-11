class LineItem < ApplicationRecord
  belongs_to :menu
  belongs_to :cart
end
