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

  def self.csv_column_headers(type)
    csv_column_headers = []
    csv_column_headers << 'Detail'
    csv_column_headers << 'Description'
    csv_column_headers << 'User'
    csv_column_headers << 'Raised user' if type == :task
    csv_column_headers << 'Group'
    csv_column_headers << ::Type::USAGES[:event_type] if type == :event
    csv_column_headers << ::Type::USAGES[:indicator] if type == :measurement
    csv_column_headers << ::Type::USAGES[:domain_of_change] if type == :story
    csv_column_headers << 'Priority' if type == :task || type == :event
    csv_column_headers << 'Status' if type == :task || type == :event
    csv_column_headers << 'Due date' if type == :task
    csv_column_headers << 'Complete' if type == :task
    csv_column_headers << 'Location'
    csv_column_headers << 'Longitude'
    csv_column_headers << 'Latitude'
    csv_column_headers << 'Update date'
    csv_column_headers << 'Created date'
  end

  def csv_columns
    csv_columns = []
    csv_columns << detail
    csv_columns << updatable.description
    csv_columns << updatable.user.full_name
    csv_columns << updatable.raised_user.full_name if updatable_type == 'Task'
    csv_columns << updatable.group.name
    csv_columns << updatable.type.description if updatable_type == 'Incivent' || updatable_type == 'Measurement' || updatable_type == 'Story'
    csv_columns << updatable.priority.description if updatable_type == 'Task' || updatable_type == 'Incivent'
    csv_columns << updatable.status.description if updatable_type == 'Task' || updatable_type == 'Incivent'
    csv_columns << updatable.due_date if updatable_type == 'Task'
    csv_columns << updatable.complete if updatable_type == 'Task'
    csv_columns << updatable.location
    csv_columns << updatable.longitude
    csv_columns << updatable.latitude
    csv_columns << created_at.to_date
    csv_columns << updatable.created_at.to_date
  end


end
