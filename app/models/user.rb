class User < ApplicationRecord
  belongs_to :building, optional: true
  acts_as_paranoid without_default_scope: true
  has_one_time_password

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :omniauth_providers => [:google_oauth2, :facebook]

  has_many :carts, dependent: :destroy
  has_many :orders, through: :carts
  has_many :notifications, dependent: :destroy

  validate :check_phone_number

<<<<<<< HEAD
  after_create :send_welcome_email

=======
>>>>>>> d1dd1ac2f750e9ed4b5059546c5352fe2612f8e2
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
        provider: auth.provider
      )
    end
    user
  end

  def active_for_authentication?
    super && !deleted_at
  end

  private
  def send_welcome_email
    SendWelcomeEmailJob.perform_now(self)
  end

  def check_phone_number
    if self.phone_number.present?
      errors.add(:phone_number, 'must be valid. Eg. 09051234567') if self.phone_number.length != 11
    end
  end
end
