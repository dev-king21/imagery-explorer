class Subscription < ApplicationRecord

  belongs_to :user

  enum kind: Constants::SUBSCRIPTION_TYPES

  validates_presence_of :kind
  validates :kind, uniqueness: { scope: :user }
  validates_inclusion_of :kind,
                         in: Constants::SUBSCRIPTION_TYPES.stringify_keys.keys,
                         message: "%s is not included in the list"

end