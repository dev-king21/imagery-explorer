class User < ApplicationRecord

  extend FriendlyId

  # Include default devise modules. Others available are:
  # :lockable,  and :omniauthable
  devise :database_authenticatable, :confirmable, :recoverable, :registerable, :rememberable, :trackable, :timeoutable,
         :validatable

  has_many :tours, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :tourbooks, dependent: :destroy

  attr_accessor :global_subscribe

  validates_presence_of   :name
  validates_uniqueness_of :name,
                          case_sensitive: false
  validates_format_of :name,
                      with: /\A[a-zA-Z0-9_]*\z/,
                      message: 'should not contain whitespaces or special characters'
  validates_acceptance_of :terms

  validates :name, length: { minimum: 5, maximum: 25 }

  has_secure_token :api_token
  friendly_id :name, use: :slugged
  acts_as_favoritor

  after_create :subscribe_to_global

  before_destroy :delete_from_global

  def subscribe_to_global
    if global_subscribe == '1'
      Mailchimp::ListUpdater.new(self).call
    end
  end

  def should_generate_new_friendly_id?
    name_changed? || slug.nil?
  end

  def self.current
    Thread.current[:user]
  end
  
  def self.current=(user)
    Thread.current[:user] = user
  end

  def delete_from_global
    Mailchimp::ListUpdater.new(self).delete
  end

end
