# frozen_string_literal: true

class UserWhitelist < ApplicationRecord
  attr_accessor :fb_profile_photo_url

  before_create :get_app_uid_for_user

  def get_app_uid_for_user
    oauth = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET'], '')
    access_token = oauth.get_app_access_token

    facebook = Koala::Facebook::API.new(access_token)
    facebook.graph_call(ENV['FB_APP_ID']+'/banned', {uid: uid}, 'post')
    banned_list = facebook.graph_call(ENV['FB_APP_ID']+'/banned')
    banned_list.each do |banned_user|
      facebook.graph_call(ENV['FB_APP_ID']+'/banned', {uid: banned_user['id']}, 'delete')
    end

    banned_uid = banned_list.first['id']

    self.fb_id = banned_uid
  end
end
