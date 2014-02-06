class AddGodUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :god_user, :boolean, :default => false
  end
end
