class User < ApplicationRecord
  belongs_to :building, optional: true
  acts_as_paranoid without_default_scope: true

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :carts, dependent: :destroy
  has_many :orders, through: :carts
  has_many :notifications, dependent: :destroy

  def unread_notifications_count
    unread_count = self.notifications.where(status: NotificationStatuses::UNREAD).count
    unread_count > 0 ? unread_count : nil
  end

  def incomplete_credentials?
    self.phone_number.blank? || self.floor.blank? || self.building_id.blank? || self.company_name.blank?
  end

  def current_cart
    carts.unordered.last
  end

  def is_admin?
    role == 'admin'
  end

  def self.from_omniauth(auth)
    data = auth.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        name: data['name'],
        email: data['email'],
        password: Devise.friendly_token[0,20],
        provider: 'google'
      )
    end
    user
  end

  def active_for_authentication?
    super && !deleted_at
  end
end
