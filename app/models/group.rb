class Group < ActiveRecord::Base
  attr_accessible :name, :description, :geo_info, :tasks_attributes

  belongs_to :account
  has_many :incivents, :dependent => :destroy
  has_many :users, :through => :memberships
  has_many :priorities, :through => :incivents
  has_many :types, :through => :incivents
  has_many :memberships, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :updates, :dependent => :destroy

  accepts_nested_attributes_for :tasks

  has_attached_file :geo_info

  validates :name, :presence => true

  default_scope :order => 'groups.created_at DESC'

  def updates_add_create(group_name, type, title)
    updates.create!(detail: "New #{type} called '#{title}' created in group '#{group_name}'.")
  end

  def updates_add_delete(group_name, type, title)
    updates.create!(detail: "The #{type} called '#{title}' in group '#{group_name}' deleted.")
  end

  def updates_add_archive(group_name, type, title)
    updates.create!(detail: "The #{type} called '#{title}' in group '#{group_name}' archived.")
  end

  def updates_add_complete(group_name, title)
    updates.create!(detail: "New task called '#{title}' in group '#{group_name}' marked as complete.")
  end

end
