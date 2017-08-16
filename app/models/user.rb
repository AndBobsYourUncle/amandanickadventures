# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:facebook]

  validates :email, presence: true

  def friend?
    facebook = Koala::Facebook::API.new(fb_token)
    @friends = facebook.get_connections('me', 'friends')

    admin_friend_users = User.where(uid: @friends.map { |f| f['id'] }, admin: true)

    admin_friend_users.any?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.image = auth.info.image
      user.admin = ENV['FB_PHOTO_SITE_ADMINS'].downcase.split(',').include? auth.info.email.to_s.downcase
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end
end
