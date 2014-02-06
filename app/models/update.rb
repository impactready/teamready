class Update < ActiveRecord::Base
  attr_accessible :detail

  belongs_to :group

  validates :detail, presence: true

end
