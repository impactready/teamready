class Type < ActiveRecord::Base

  attr_accessible :description, :usage
  attr_protected :account_id

  has_many :incivents
  has_many :stories
  has_many :measurements
  belongs_to :account

  validates :description, :usage, presence: true
  validates :description, length: { maximum: 40 }

  USAGES = {
    event_type: 'Event type',
    indicator: 'Indicator',
    domain_of_change: 'Domain of change'
  }
end
