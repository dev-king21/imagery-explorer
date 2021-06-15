# frozen_string_literal: true
class UserPolicy < ApplicationPolicy

  def generate_new_token?
    info?
  end

  def tours?
    user && record.id == user.id
  end

end
