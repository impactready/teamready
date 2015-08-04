class AddTypeToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :update_type, :string, default: "", null: false
  end
end
