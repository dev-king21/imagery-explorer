# frozen_string_literal: true
class Tour < ApplicationRecord

  include PgSearch::Model
  extend FriendlyId

  enum tour_type: Constants::TOUR_TYPES
  enum transport_type: Constants::TRANSPORT_TYPES

  belongs_to :user, :counter_cache => true

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :photos, dependent: :destroy
  has_many :countries, through: :photos
  has_many :tour_tourbooks, dependent: :destroy
  has_many :tourbooks, -> { distinct }, through: :tour_tourbooks, inverse_of: :tours

  # accepts_nested_attributes_for :photos

  validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 70 }
  validates :description, length: { maximum: 16777215 }
  validates :tourer_tour_id, allow_blank: true, length: { maximum: 10 }
  validates :tourer_version, length: { maximum: 5 }
  validates :tour_type, presence: true
  validates :transport_type, presence: true

  validates_uniqueness_of :tourer_tour_id, :scope => :user_id, allow_blank: true

  validates_associated :tags
  validates_associated :countries

  validate :tags_amount
  validate :tags_length
  validate :tour_type_should_be_valid
  validate :transport_type_should_be_valid
  # validate :types_dependency

  friendly_id :name, :use => :scoped, :scope => :user

  pg_search_scope :search,
                  against: [
                      :name,
                      :description
                  ],
                  associated_against: {
                      tags: [:name],
                  },
                  :using => {
                      :tsearch => {:prefix => true}
                  }

  paginates_per Constants::ITEMS_PER_PAGE[:tours]

  def self.validates_uniqueness(*attribute_names)
    configuration = attribute_names.extract_options!
    validates_each(attribute_names) do |record, association_name, value|
      track_values = {}
      attribute_name = configuration[:attribute]
      value.map.with_index do |object, index|
        attribute_value = object.try(attribute_name)
        attribute_value = attribute_value.try(:downcase) if configuration[:case_sensitive] == false

        unless configuration[:allow_blank] == true && attribute_value.blank?
          if track_values[attribute_value].present?
            track_values[attribute_value].push({index: index, record: record})
          else
            track_values[attribute_value] = [{index: index, record: record}]
          end
        end

        track_values.each do |key, track_value|
          if track_value.count > 1
            track_value.each do |value|
              error_key = "#{association_name}[#{value[:index]}].#{attribute_name}"
              message = configuration[:message]
              value[:record].errors.add(error_key, message)
            end
          end
        end
      end
    end
  end

  # validates_uniqueness :photos, { attribute: :tourer_photo_id,
  #                                 case_sensitive: false,
  #                                 allow_blank: true,
  #                                 message: "Photo's tourer_photo_id should be unique per tour" }

  # Use default slug, but upper case and with underscores
  def normalize_friendly_id(string)
    super.gsub('-', '_')
  end

  def should_generate_new_friendly_id?
    name_changed? || slug.nil?
  end

  def countries=(codes_string)
    countries = []
    codes_string.split(', ').uniq.each do |code|
      countries << Country.find_or_initialize_by(code: code)
    end
    super countries
  end

  # for case if we will need to pass tags as a string and validate its length
  def tag_names=(names_string)
    self.tags = prepare_string(names_string).split(', ').map do |name|
      Tag.find_or_initialize_by(name: name.strip.downcase)
    end
  end

  def prepare_string(string)
    string.strip.chomp(',')
  end

  def tag_names
    self.tags.map(&:name).join(', ')
  end

  def tags_check(name)
    unless name.match(/\A[a-zA-Z0-9]*\z/)
      self.errors.add(:tags, "#{name} should not contain whitespaces or special characters") and return
    end
  end

  def tags_amount
    errors.add(:tags, "too much tags (maximum is #{Constants::TAGS_AMOUNT[:tour]} tags)") if tags.length > Constants::TAGS_AMOUNT[:tour]
  end

  def tags_length
    errors.add(:tags, "too much characters (maximum is #{Constants::TAGS_LENGTH[:tour]} tags)") if tag_names.length > Constants::TAGS_LENGTH[:tour]
  end

  # custom validation with message for enum :tour_type (as it raises ArgumentError in the case of wrong value)
  # standard validation doesn't help (validates_inclusion_of)
  def tour_type=(value)
    super value
    @tour_type_backup = nil
  rescue ArgumentError => exception
    error_message = 'is not a valid tour_type'
    if exception.message.include? error_message
      @tour_type_backup = value
      self[:tour_type] = nil
    else
      raise
    end
  end

  def tour_type_should_be_valid
    if @tour_type_backup
      error_message = "#{@tour_type_backup} is not a valid tour_type"
      errors.add(:tour_type, error_message)
    end
  end

  def transport_type=(value)
    super value
    @transport_type_backup = nil
  rescue ArgumentError => exception
    error_message = 'is not a valid transport_type'
    if exception.message.include? error_message
      @transport_type_backup = value
      self[:transport_type] = nil
    else
      raise
    end
  end

  def transport_type_should_be_valid
    if @transport_type_backup
      error_message = "#{@transport_type_backup} is not a valid transport_type"
      errors.add(:transport_type, error_message)
    end
  end

  def types_dependency
    if self[:tour_type].present? && self[:transport_type].present?
      error_message = "#{self[:tour_type]} and #{self[:transport_type]} mismatch"
      errors.add(:types_mismatch, error_message) unless Constants::DEPENDENCY_OF_TYPES[self[:tour_type]].include? self[:transport_type]
    end
  end
  #---------------------------------------------------------------------------------------------------------

end
