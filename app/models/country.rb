class Country < ApplicationRecord

  include PgSearch::Model

  has_many :tours, through: :photos
  has_many :photos

  validates :code, presence: true, uniqueness: true, inclusion: { in: ISO3166::Country.all.map(&:alpha2) }

  before_save :set_name

  pg_search_scope :search,
                  against: [
                      :name
                  ]

  def set_name
    country = ISO3166::Country.new(self.code)
    self.name = country.name if country
  end

end
