class RenameGodUserToAdminUser < ActiveRecord::Migration
  def change
    rename_column :users, :god_user, :admin_user
  end
end
