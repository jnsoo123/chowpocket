class Menu < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  acts_as_paranoid

  has_many :menu_clusters, dependent: :destroy
  has_many :clusters, dependent: :destroy
end
