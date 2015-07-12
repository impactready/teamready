class Measurement < ActiveRecord::Base

  belongs_to :group
  belongs_to :user
  belongs_to :type

  has_attached_file :measurement_image, {styles: { medium: "390x390#", thumb: "90x90#" }}.merge(ADD_PP_OPTIONS)
end
