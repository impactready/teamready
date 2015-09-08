class AddApiKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :string, null: false, default: ""
  end
end
