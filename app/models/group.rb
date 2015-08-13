class Group < ActiveRecord::Base
  attr_accessible :name, :description, :geo_info, :tasks_attributes

  belongs_to :account
  has_many :incivents, dependent: :destroy
  has_many :users, through: :memberships
  has_many :priorities, through: :incivents
  has_many :types, through: :incivents
  has_many :memberships, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :updates, dependent: :destroy
  has_many :measurements, dependent: :destroy

  accepts_nested_attributes_for :tasks

  has_attached_file :geo_info

  validates_attachment_file_name :geo_info, matches: [/kml\Z/, /kmz\Z/]

  validates :name, presence: true

  default_scope { order(created_at: :desc) }

  def updates_add_create(type, updatable)
    updatable.updates.create!(group_id: self.id, detail: "New #{type} called '#{updatable.description}' created in group '#{self.name}'.")
  end

  def updates_add_delete(type, updatable)
    updatable.updates.create!(group_id: self.id, detail: "The #{type} called '#{updatable.description}' in group '#{self.name}' deleted.")
  end

  def updates_add_archive(type, updatable)
    updatable.updates.create!(group_id: self.id, detail: "The #{type} called '#{updatable.description}' in group '#{self.name}' archived.")
  end

  def updates_add_complete(updatable)
    updatable.updates.create!(group_id: self.id, detail: "Task called '#{updatable.description}' in group '#{self.name}' marked as complete.")
  end

end
