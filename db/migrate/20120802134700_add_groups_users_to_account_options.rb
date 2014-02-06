class AddGroupsUsersToAccountOptions < ActiveRecord::Migration
  def change
    add_column :account_options, :users, :integer
    add_column :account_options, :groups, :integer
  end
end
