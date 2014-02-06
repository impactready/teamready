class AddMessageToLaunchInterests < ActiveRecord::Migration
  def change
    add_column :launch_interests, :message, :text
  end
end
