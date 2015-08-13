class Measurement < ActiveRecord::Base

  belongs_to :group
  belongs_to :user
  belongs_to :type

  has_many :updates

  has_attached_file :measurement_image, {styles: { medium: "390x390#", thumb: "90x90#" }}.merge(ADD_PP_OPTIONS)

  validates_attachment_content_type :measurement_image, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  attr_accessible :location, :description, :longitude, :latitude, :type_id, :measurement_image, :group_id, :archive
  attr_protected :user_id

  validates :description, :user_id, :type_id, :group_id, :location, :longitude, :latitude, presence: true

  geocoded_by :location
  reverse_geocoded_by :latitude, :longitude, address: :location

  scope :default_order, -> { order('created_at DESC') }

  scope :unarchived, -> { where(archive: false) }
  scope :archived, -> { where(archive: true) }

  before_save :cleanup

  before_validation :reverse_geocode, if: :has_coordinates
  before_validation :geocode, if: :has_location, unless: :has_coordinates

  # Called to limit incivents shown according to a search field
  def self.search(user, search)
    if search
      measurements_from_groups_joined_by(user).where("description LIKE ?", "%#{search}%")
    else
      measurements_from_groups_joined_by(user)
    end
  end

  def self.measurements_from_groups_joined_by(user)
    group_ids = user.group_ids
    unless group_ids.empty?
      where(group_id: group_ids)
    else
      []
    end
  end

  private

  def cleanup
    self.location = self.location.chomp
    self.description = self.description.chomp
  end

  def has_coordinates
    self.longitude && self.latitude
  end

  def has_location
    self.location
  end

end
