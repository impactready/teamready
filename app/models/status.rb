class Status < ActiveRecord::Base

  attr_accessible :description
  attr_protected :account_id

  has_many :incivents
  has_many :tasks
  has_many :users, through: :incivents
  has_many :types, through: :incivents
  has_many :priorities, through: :incivents
  has_many :groups, through: :incivents
  belongs_to :account

  validates :description, presence: true
  validates :description, length: { maximum: 40 }

end
