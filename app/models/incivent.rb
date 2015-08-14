class Incivent < ActiveRecord::Base

  belongs_to :user, foreign_key: "raised_user_id"
  belongs_to :priority
  belongs_to :type
  belongs_to :status
  belongs_to :group

  has_many :updates, as: :updatable

  has_attached_file :incivent_image, {styles: { medium: "390x390#", thumb: "90x90#" }}.merge(ADD_PP_OPTIONS)

  validates_attachment_content_type :incivent_image, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  attr_accessible :location, :description, :longitude, :latitude, :priority_id, :type_id, :status_id, :incivent_image, :group_id, :archive
  attr_protected :raised_user_id

  geocoded_by :location
  reverse_geocoded_by :latitude, :longitude, address: :location

  validates :raised_user_id, presence: true, numericality:  { only_integer: true }
  validates :priority_id, presence: true
  validates :status_id, presence: true
  validates :group_id, presence: true
  #validates :location, presence: true
  validates :type_id, presence: true
  validates :description, presence: true
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }

  before_validation :reverse_geocode, if: :has_coordinates
  before_validation :geocode, if: :has_location, unless: :has_coordinates

  before_save :cleanup

  scope :default_order, -> { order('created_at DESC') }

  scope :unarchived, -> { where(archive: false) }
  scope :archived, -> { where(archive: true) }

  # Called to limit incivents shown according to a search field
  def self.search(user, search)
    if search
      incivents_from_groups_joined_by(user).where("name LIKE ? OR description LIKE ?", "%#{search}%", "%#{search}%")
    else
      incivents_from_groups_joined_by(user)
    end
  end

 # Called from search above, find all the incivents from groups joined by the passed user
  def self.incivents_from_groups_joined_by(user)
    group_ids = user.group_ids
 #   where("group_id IN ? OR raised_user_id = ?", "(#{group_ids.join(", ")}", user)
    unless group_ids.empty?
      where("group_id IN (#{group_ids.join(", ")}) OR raised_user_id = ?", user)
    else
      where("raised_user_id = ?", user)
    end
  end

  private

  def cleanup
    self.location = self.location.chomp
    self.description = self.description.chomp
  end

  def has_coordinates
    self.longitude && self.latitude && self.longitude_changed? && self.latitude_changed?
  end

  def has_location
    self.location && self.location_changed?
  end

end
