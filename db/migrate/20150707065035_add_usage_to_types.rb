class AddUsageToTypes < ActiveRecord::Migration
  def change
    add_column :types, :usage, :string, null: false, default: ''
  end
end
