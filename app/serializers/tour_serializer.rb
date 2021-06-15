# frozen_string_literal: true
class TourSerializer < ActiveModel::Serializer

  attributes %i[
                id
                name
                description
                countries
                tags
                tour_type
                transport_type
                tourer
                created_at
                updated_at
                user_id
              ]

  def countries
    object.countries.any? ? object.countries.map(&:code).uniq : []
  end

  def tags
    object.tags.any? ? object.tags.map(&:name).uniq : []
  end

  def tourer
    {
        tour_id: object.tourer_tour_id,
        version: object.tourer_version
    }
  end

end
