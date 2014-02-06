class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :paypal_payer_token
      t.string :recurring_profile_token

      t.timestamps
    end
  end
end
