class AddApdatableToUpdates < ActiveRecord::Migration
  def change
    add_reference :updates, :updatable, polymorphic: true, index: true
  end
end
