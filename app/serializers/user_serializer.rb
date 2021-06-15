# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  attributes %i[id username]

  def username
    object.name
  end
end
