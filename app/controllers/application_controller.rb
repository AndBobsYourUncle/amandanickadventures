# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def new_session_path(_scope)
    new_user_session_path
  end
end
