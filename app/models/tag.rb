class Tag < ApplicationRecord

  has_many :taggings
  has_many :tours, through: :taggings

  validates :name, presence: true, uniqueness: true

  before_create :lower_name

  def lower_name
    name.strip.downcase
  end

end
