class Story < ActiveRecord::Base

  belongs_to :user
  belongs_to :group
  belongs_to :type

  has_many :updates, as: :updatable

  has_attached_file :story_image, {styles: { medium: "390x390#", thumb: "90x90#" }}.merge(ADD_PP_OPTIONS)

  validates_attachment_content_type :story_image, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  attr_accessible :description, :location, :latitude, :longitude, :group_id, :type_id
  attr_protected :user_id

  geocoded_by :location
  reverse_geocoded_by :latitude, :longitude, address: :location

  validates :description, presence: true
  validates :group_id, presence: true, numericality:  { only_integer: true }
  validates :user_id, presence: true, numericality:  { only_integer: true }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }

  scope :default_order, -> { order('created_at DESC') }

  scope :unarchived, -> { where(archive: false) }
  scope :archived, -> { where(archive: true) }

  before_validation :reverse_geocode, if: :has_coordinates
  before_validation :geocode, if: :has_location, unless: :has_coordinates

  before_save :cleanup

  def self.stories_from_groups_joined_by(user)
    group_ids = user.group_ids
    unless group_ids.empty?
      where(group_id: group_ids)
    else
      []
    end
  end

  def image
    story_image unless story_image.url == '/story_images/original/missing.png'
  end

  private

  def cleanup
    self.description = self.description.chomp
  end

  def has_coordinates
    self.longitude && self.latitude && self.longitude_changed? && self.latitude_changed?
  end

  def has_location
    self.location && self.location_changed?
  end

end
