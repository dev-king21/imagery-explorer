# frozen_string_literal: true
class TourPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  class Scope < Scope
    def resolve
      case
        when user.blank?
          scope.none
        else
          scope.where(user: user)
      end
    end
  end

end
