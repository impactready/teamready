class AddCompleteIndicatorToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :complete, :boolean, default: false
  end
end
