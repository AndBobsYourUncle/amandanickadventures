# frozen_string_literal: true

class PagesControllerPolicy < ApplicationPolicy
  def home?
    user.admin? or user.friend?
  end
end
