require 'koala'

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  validates :email, uniqueness: true, presence: true

  has_many :comments, dependent: :destroy

  def display_name
    if first_name || last_name
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.name
      user.friends = koala(auth.credentials.token)
    end
  end

  def self.koala(token)
    begin
      @graph = Koala::Facebook::API.new(token)
      @graph.get_connections('me', 'taggable_friends')
    rescue Koala::Facebook::APIError => e
      Rails.logger.error(e)
      {}
    end
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
