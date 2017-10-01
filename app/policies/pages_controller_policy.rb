# frozen_string_literal: true

class PagesControllerPolicy < ApplicationPolicy
  def home?
    (user.admin? or user.friend? or user.whitelisted?) and user.not_blacklisted?
  end
end
