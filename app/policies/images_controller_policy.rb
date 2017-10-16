# frozen_string_literal: true

class ImagesControllerPolicy < ApplicationPolicy
  def server_image?
    user.present? && ((user.admin? or user.friend? or user.whitelisted?) and user.not_blacklisted?)
  end
end
