class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.string :description
      t.integer :account_id

      t.timestamps
    end
  end
end
