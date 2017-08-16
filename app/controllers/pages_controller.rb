# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    authorize self
  end

  def not_a_friend
  end
end
