# frozen_string_literal: true

module ActiveAdmin
  class CommentPolicy < ActiveAdminPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end
  end
end
