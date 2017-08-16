# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Koala::Facebook::AuthenticationError, with: :user_not_authorized

  def user_not_authorized _auth_error = nil
    flash[:alert] = 'You need to login with Facebook to continue.'

    redirect_to destroy_user_session_path
  end

  def new_session_path(_scope)
    new_user_session_path
  end
end
