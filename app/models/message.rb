class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :group

  attr_accessible :description, :location, :latitude, :longitude, :group_id
  attr_protected :user_id

  geocoded_by :location
  reverse_geocoded_by :latitude, :longitude, :address => :location

  validates :description, :presence => true
  validates :group_id, :presence => true, :numericality =>  { :only_integer => true }
  validates :user_id, :presence => true, :numericality =>  { :only_integer => true }
  validates :longitude, :numericality => { :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180 }
  validates :latitude, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }

  scope :default_order, -> { order('created_at DESC') }

  scope :unarchived, -> { where(:archive => false) }
  scope :archived, -> { where(:archive => true) }

  before_validation :reverse_geocode, :if => :has_coordinates
  before_validation :geocode, :if => :has_location, :unless => :has_coordinates

  before_save :cleanup

  def self.messages_from_groups_joined_by(user)
    group_ids = user.group_ids
    unless group_ids.empty?
      where("group_id IN (#{group_ids.join(", ")})")
    else
      []
    end
  end

  private

  def cleanup
    self.description = self.description.chomp
  end

  def has_coordinates
    self.longitude && self.latitude
  end

  def has_location
    self.location
  end

end
