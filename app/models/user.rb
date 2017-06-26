class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :carts, dependent: :delete_all
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
end
