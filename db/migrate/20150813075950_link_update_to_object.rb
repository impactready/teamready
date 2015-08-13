class LinkUpdateToObject < ActiveRecord::Migration
  def change
    Update.all.each do |update_item|
      description = update_item.detail[/called\s\'(.*?)\'/].gsub('called ','').gsub("'", '')
      puts update_item.id
      puts description
      parent_class = update_item.update_type.capitalize
      puts parent_class
      parent_class = 'Incivent' if parent_class == 'Event'
      parent = class_eval(update_item.update_type.capitalize).find_by(description: description)
      puts parent
      puts "------------"
      # update.
    end
  end
end
