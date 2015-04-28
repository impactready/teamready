class RemoveIndexFromLaunchInterests < ActiveRecord::Migration
  def up
  	remove_index :launch_interests, name: "index_launch_interests_on_email_address"
  end

  def down
  	add_index :launch_interests, name: "index_launch_interests_on_email_address", unique: :true
  end
end
