class RequestPolicy < ApplicationPolicy

  # INDEX
  class Scope < Scope
    def resolve
      scope.where(disable: false)
    end
  end

  def history?
    true
  end

  def show?
    user != nil
  end

  def new?
    create?
  end

  def create?
    true
  end

  def edit?
    # !user.nil?
    update?
  end

  def update?
    # Qui peut faire ca (user (current user) record la request)
    # !user.nil? # user != nil
    user.nil? || record.email == user.email
  end

  def confirmation?
    true
  end

  def cancel?
    disable?
  end

  def disable?
    user.nil? || record.email == user.email
  end

  def done?
    user != nil # && user.admin
  end

  def decline?
    user != nil
  end

  def personal_note?
    user != nil
    # user.nil? || record.email == user.email
  end
end
