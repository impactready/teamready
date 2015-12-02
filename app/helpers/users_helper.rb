module UsersHelper

  # Call mostly in views to find a user by id for which a model association does not exist
  def user_locate_by_id(id)
    User.find_by(id: id)
  end

end
