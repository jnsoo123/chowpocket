class User < ApplicationRecord
  belongs_to :building
  acts_as_paranoid without_default_scope: true

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :omniauth_providers => [:google_oauth2]

  validates_presence_of :name, :email, :phone_number, :company_name, :floor, :building_id

  has_many :carts, dependent: :destroy
  has_many :orders, through: :carts

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
