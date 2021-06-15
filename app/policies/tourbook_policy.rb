# frozen_string_literal: true
class TourbookPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user && record.user_id == user.id
  end

  def destroy?
    update?
  end

  def add_item?
    record && user && record.user_id == user.id
  end

  def remove_item?
    add_item?
  end

end