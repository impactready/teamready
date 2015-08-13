class LinkUpdateToObject < ActiveRecord::Migration
  def change
    Update.all.each do |update_item|
      description = update_item.detail[/called\s\'(.*?)\'/].gsub('called ','').gsub("'", '')
      puts update_item.id
      puts update_item.detail
      puts description
      parent_class = update_item.update_type.capitalize
      parent_class = 'Incivent' if parent_class == 'Event'
      puts parent_class
      parent = class_eval(parent_class).find_by(description: description)
      parent ||= class_eval(parent_class).find_by(name: description) if class_eval(parent_class).respond_to(:name)
      puts parent
      puts "------------"
      # update.
    end
  end
end
