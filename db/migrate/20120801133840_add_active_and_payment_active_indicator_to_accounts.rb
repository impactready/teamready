class AddActiveAndPaymentActiveIndicatorToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :payment_active, :boolean, default: false
    add_column :accounts, :active, :boolean, default: false
  end
end
