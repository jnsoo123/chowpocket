class Menu < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  has_many :menu_clusters
end
