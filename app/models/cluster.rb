class Cluster < ApplicationRecord
  has_many :menu_clusters, dependent: :destroy
end
