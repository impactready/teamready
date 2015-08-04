class AddTypeToUpdates < ActiveRecord::Migration
  def change
    add_column :updates, :type, :string, default: "", null: false
  end
end
