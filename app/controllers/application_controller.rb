# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Koala::Facebook::AuthenticationError, with: :user_not_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_friend

  def access_denied _auth_error = nil
    redirect_to root_path
  end

  def user_not_authorized _auth_error = nil
    flash[:alert] = 'You need to login with Facebook to continue.'

    redirect_to destroy_user_session_path
  end

  def user_not_friend _auth_error = nil
    flash[:alert] = 'You need to be a friend to see this site.'

    redirect_to not_a_friend_path
  end

  def new_session_path(_scope)
    new_user_session_path
  end
end
