class AddSubjectToLaunchInterests < ActiveRecord::Migration
  def change
    add_column :launch_interests, :subject, :string
  end
end
