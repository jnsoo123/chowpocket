class MenuCluster < ApplicationRecord
  belongs_to :menu
  belongs_to :order
  belongs_to :cluster, counter_cache: true
end
