class CreateIndicatorMeasurements < ActiveRecord::Migration
  def change
    create_table :indicator_measurements do |t|
      t.string :description
      t.integer :user_id
      t.integer :group_id
      t.integer :indicator_id
      t.string :location
      t.float :longitude
      t.float :latitude
      t.boolean :archive, default: false

      t.timestamps
    end

    add_attachment :indicator_measurements, :measurement_image
  end
end
