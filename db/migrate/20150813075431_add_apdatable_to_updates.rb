class AddApdatableToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :updatable_id, :integer, null: false
    add_column :updates, :updatable_type, :string, null: false
    remove_column :updates, :update_type, :string

    add_index :updates, :updatable_id, name: "updates_updatable_id"
  end
end
