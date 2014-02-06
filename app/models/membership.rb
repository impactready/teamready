class Membership < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to :user
  belongs_to :group
  
  validates :user_id, :presence => true
  validates :group_id, :presence => true

end