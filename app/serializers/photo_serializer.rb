# frozen_string_literal: true
require 'uri'
class PhotoSerializer < ActiveModel::Serializer

  attributes %i[
                 id
                 tour_id
                 image
                 filename
                 camera_make
                 camera_model
                 taken_at
                 latitude
                 longitude
                 elevation_meters
                 address
                 google
                 streetview
                 tourer
                 opentrailview
                 favoritable_score
                 favoritable_total
                 created_at
                 updated_at
               ]

  def country
    object.country.present? ? object.country.name : ''
  end

  def address
    {
        locality: object.address['locality'],
        administrative_area_level_3: object.address['administrative_area_level_3'],
        administrative_area_level_2: object.address['administrative_area_level_2'],
        administrative_area_level_1: object.address['administrative_area_level_1'],
        postal_code: object.address['postal_code'],
        country: object.address['country'],
        country_code: object.address['country_code'],
        place_id: object.address['place_id'],
        plus_code: object.address['plus_code']
    }
  end

  def streetview
    {
        photo_id: object.streetview['photo_id'],
        capture_time: object.streetview['capture_time'],
        share_link: object.streetview['share_link'],
        download_url: object.streetview['download_url'],
        thumbnail_url: object.streetview['thumbnail_url'],
        lat: object.streetview['lat'],
        lon: object.streetview['lon'],
        altitude: object.streetview['altitude'],
        heading: object.streetview['heading'],
        pitch: object.streetview['pitch'],
        roll: object.streetview['roll'],
        level: object.streetview['level'],
        connections: object.streetview['connections']
    }
  end

  def tourer
    return {} unless object.tourer

    if object.tourer['connections']
      connections = JSON.parse(object.tourer['connections'])
    else
      connections = {}
    end

    {
        photo_id: object.tourer['photo_id'],
        version: object.tourer['version'],
        heading_degrees: object.tourer['heading_degrees'],
        connections: connections
    }
  end

  def opentrailview
    {
        photo_id: object.opentrailview && object.opentrailview['photo_id']
    }
  end
end
