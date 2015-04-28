class AddAchiveToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :archive, :boolean, default: false
  end
end
