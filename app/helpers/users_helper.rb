# frozen_string_literal: true
module UsersHelper

  def user_tours_title(user)
    if current_user and current_user.id == user.id
      'Your Tours'
    else
      "#{user.try(:name)} Tours"
    end
  end

end
