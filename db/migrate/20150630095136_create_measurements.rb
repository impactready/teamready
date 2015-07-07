class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.string :description
      t.integer :user_id
      t.integer :group_id
      t.integer :type_id
      t.string :location
      t.float :longitude
      t.float :latitude
      t.boolean :archive, default: false

      t.timestamps
    end

    add_attachment :measurements, :measurement_image
  end
end
