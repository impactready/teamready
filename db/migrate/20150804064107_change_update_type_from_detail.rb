class ChangeUpdateTypeFromDetail < ActiveRecord::Migration
  def change
    Update.all.each do |update|
      if update.detail.include?('task') || update.detail.include?('Task')
        update.update_attributes(update_type: Update::TYPES[:task])
      elsif update.detail.include?('event')
        update.update_attributes(update_type: Update::TYPES[:event])
      elsif update.detail.include?('story') || update.detail.include?('message')
        update.update_attributes(update_type: Update::TYPES[:story])
      elsif update.detail.include?('measurement')
        update.update_attributes(update_type: Update::TYPES[:measurement])
      end
    end
  end
end
