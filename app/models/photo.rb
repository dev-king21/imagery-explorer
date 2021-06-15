# frozen_string_literal: true
class Photo < ApplicationRecord

  include PgSearch::Model

  mount_uploader :image, PhotoUploader

  belongs_to :tour, counter_cache: true
  belongs_to :country

  store_accessor :address, :cafe, :road, :suburb, :county, :region, :state, :postcode, :country_code
  store_accessor :google, :plus_code_global_code, :plus_code_compound_code
  store_accessor :streetview,  :capture_time, :share_link, :download_url, :thumbnail_url, :lat, :lon, :altitude, :heading, :pitch, :roll, :level, :connections
  store_accessor :tourer, :connections
  store_accessor :opentrailview, :photo_id

  validates :image, file_size: { less_than: 30.megabytes }, presence: true
  validates :filename, presence: true
  validates :taken_at, presence: true
  validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }, length: { maximum: 20 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, length: { maximum: 20 }
  validates :elevation_meters, numericality: true, length: { maximum: 6 }
  validates :camera_make, length: { maximum: 255 }
  validates :camera_model, length: { maximum: 255 }
  validates :country, presence: true
  validates :country_code, presence: true
  validates :plus_code_global_code, length: { maximum: 255 }
  validates :plus_code_compound_code, length: { maximum: 255 }
  validates :lat, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }, length: { maximum: 20 }, allow_blank: true
  validates :lon, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }, length: { maximum: 20 }, allow_blank: true
  validates :heading, numericality: { greater_than_or_equal_to:  0, less_than_or_equal_to:  360 }, allow_blank: true
  validates :pitch, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }, allow_blank: true
  validates :roll, numericality: { greater_than_or_equal_to:  0, less_than_or_equal_to:  360 }, allow_blank: true
  validates :photo_id, allow_blank: true, length: { maximum: 20 }
  validates :tourer_photo_id, allow_blank: true, length: { maximum: 10 }
  # validates :connections, presence: true

  validates_associated :country

  before_destroy :remove_image

  pg_search_scope :search,
                  against: [],
                  associated_against: {
                      country: [:code]
                  }
  paginates_per Constants::ITEMS_PER_PAGE[:photos]
  acts_as_favoritable

  def country=(country_code)
    country = Country.find_or_create_by(code: country_code)
    super country
  end

  def s3_dir
    self.tour.id
  end

end
