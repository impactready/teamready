class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.integer :group_id
      t.string :detail
      t.timestamps
    end
  end
end
