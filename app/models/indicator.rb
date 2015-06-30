class Indicator < ActiveRecord::Base

  attr_accessible :description
  attr_protected :account_id

  belongs_to :account
  has_many :indicator_measurements

  validates :description, presence: true, length: { maximum: 100 }
end
