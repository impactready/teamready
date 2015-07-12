class ChangeMessagesToStoriesAndAddAttachedFile < ActiveRecord::Migration
  def change
    rename_table :messages, :stories
    add_attachment :stories, :story_image
    add_column :stories, :type_id, :integer, null: :false, default: 1
  end
end
