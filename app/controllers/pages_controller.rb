# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    facebook = Koala::Facebook::API.new(session['facebook.token'])
    @friends = facebook.get_connections('me', 'friends')
  end
end
