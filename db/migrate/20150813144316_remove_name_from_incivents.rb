class RemoveNameFromIncivents < ActiveRecord::Migration
  def change
    remove_column :incivents, :name, :string
  end
end
