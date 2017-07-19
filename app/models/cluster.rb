class Cluster < ApplicationRecord
  has_many :menu_clusters, dependent: :destroy
  belongs_to :menu
end
