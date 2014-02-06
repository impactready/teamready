class AddAccountIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :account_id, :integer
  end
end
