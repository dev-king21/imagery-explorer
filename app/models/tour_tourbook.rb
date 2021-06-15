# frozen_string_literal: true
class TourTourbook < ApplicationRecord

  belongs_to :tour, counter_cache: :tourbooks_count
  belongs_to :tourbook, counter_cache: :tours_count

  validates_uniqueness_of :tour_id, scope: :tourbook_id, message: 'has already been added.'

end
