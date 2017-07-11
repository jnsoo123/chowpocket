class Cluster < ApplicationRecord
  has_many :menu_cluster, dependent: :destroy
end
