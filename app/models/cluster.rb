class Cluster < ApplicationRecord
  acts_as_paranoid
  has_many :menu_clusters, dependent: :destroy
  belongs_to :menu
end
