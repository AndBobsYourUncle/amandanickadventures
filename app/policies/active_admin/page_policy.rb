# frozen_string_literal: true

module ActiveAdmin
  class PagePolicy < ActiveAdminPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def show?
      user.admin?
    end
  end
end
