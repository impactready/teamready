class Type < ActiveRecord::Base

  attr_accessible :description, :usage
  attr_protected :account_id

  has_many :incivents
  has_many :users, through: :incivents
  has_many :priorities, through: :incivents
  has_many :statuses, through: :incivents
  has_many :groups, through: :incivents
  belongs_to :account

  validates :description, presence: true

  USAGES = {
    event_type: 'Event type',
    indicator: 'Indicator',
    domain_of_change: 'Domain of change'
  }
end
