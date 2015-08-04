class Update < ActiveRecord::Base
  attr_accessible :detail, :update_type

  belongs_to :group

  validates :detail, presence: true

  TYPES = {
    event: 'event',
    story: 'story',
    task: 'task',
    measurement: 'measurement'
  }

end
