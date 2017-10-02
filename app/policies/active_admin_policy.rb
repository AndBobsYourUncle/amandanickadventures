# frozen_string_literal: true

class ActiveAdminPolicy
  attr_reader :user, :record

  def initialize user, record
    @user = user
    @record = record
  end

  def index?
    user&.admin?
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def upload_images?
    user&.admin?
  end

  def create?
    user&.admin?
  end

  def new?
    create?
  end

  def update?
    user&.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin?
  end

  def scope
    Pundit.policy_scope! user, record.class
  rescue Pundit::NotDefinedError => e
    raise e unless ActiveAdminPolicy && ActiveAdminPolicy.const_defined?(:Scope)
    ActiveAdminPolicy::Scope.new(user, record.class).resolve
  end

  class Scope
    attr_reader :user, :scope

    def initialize user, scope
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
