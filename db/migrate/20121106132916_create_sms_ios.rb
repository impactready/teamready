class CreateSmsIos < ActiveRecord::Migration
  def change
    create_table :sms_ios do |t|

      t.timestamps
    end
  end
end
