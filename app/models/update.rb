class Update < ActiveRecord::Base
  attr_accessible :detail, :group_id

  belongs_to :group
  belongs_to :updatable, polymorphic: true

  validates :detail, presence: true

  TYPES = {
    event: 'event',
    story: 'story',
    task: 'task',
    measurement: 'measurement'
  }

end
