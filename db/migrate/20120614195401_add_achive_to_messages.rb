class AddAchiveToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :archive, :boolean, default: false
  end
end
