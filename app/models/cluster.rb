class Cluster < ApplicationRecord
  has_many :orders, dependent: :destroy
end
