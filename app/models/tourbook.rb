# frozen_string_literal: true
class Tourbook < ApplicationRecord

  include PgSearch::Model
  extend FriendlyId

  belongs_to :user, :counter_cache => true

  has_many :tour_tourbooks, dependent: :destroy
  has_many :tours, through: :tour_tourbooks, inverse_of: :tourbooks

  validates :name, presence: true, uniqueness: {scope: :user_id}, length: { maximum: 70 }
  validates :description, presence: true, length: { maximum: 240 }

  paginates_per Constants::ITEMS_PER_PAGE[:tourbooks]
  pg_search_scope :search,
                  against: [
                      :name,
                      :description
                  ],
                  :using => {
                      :tsearch => {:prefix => true}
                  }
  friendly_id :name, use: :slugged

  # Use default slug, but upper case and with underscores
  def normalize_friendly_id(string)
    super.gsub('-', '_')
  end

  def should_generate_new_friendly_id?
    name_changed? || slug.nil?
  end

  def build_tour_tourbooks(tour_ids)
    if tour_ids.present?
      tour_ids.each do |tour_id|
        tour = Tour.find_by(id: tour_id)
        self.tour_tourbooks.build(tour_id: tour.id) if tour
      end
    end
  end

end
