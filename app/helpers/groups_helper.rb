module GroupsHelper

  def group_save_unsuccessful
    flash[:error] = "The group was not successfully created."
    render 'new'
  end

  # Get a paperclip url that can be passed to Application.js
  def attachment_url(attachment)
    unless attachment.url == "/geo_infos/original/missing.png"
      "#{root_url}#{attachment.url.gsub(/^\//, '')}"
    else
      ""
    end
  end

 # Concatinate the arrays of names, longtitudes and latitudes for both the impacts and the incivent in one group for sending to Google Maps
 def group_lats(group)
  group_latarray = []
  group_latarray.push(incivents_lats(group.incivents)) unless group.incivents.empty?
  group_latarray.push(tasks_lats(group.tasks)) unless group.tasks.empty?
  group_latarray.push(messages_lats(group.messages)) unless group.messages.empty?
  return group_latarray.join("%|%")
 end

 def group_longs(group)
  group_longarray = []
  group_longarray.push(incivents_longs(group.incivents)) unless group.incivents.empty?
  group_longarray.push(tasks_longs(group.tasks)) unless group.tasks.empty?
  group_longarray.push(messages_longs(group.messages)) unless group.messages.empty?
  return group_longarray.join("%|%")
 end

 def group_feature_names(group)
  group_namearray = []
  group_namearray.push(incivents_names(group.incivents)) unless group.incivents.empty?
  group_namearray.push(tasks_names(group.tasks)) unless group.tasks.empty?
  group_namearray.push(messages_names(group.messages)) unless group.messages.empty?
  return group_namearray.join("%|%")
 end

 def group_feature_urls(group)
  group_urlarray = []
  group_urlarray.push(incivents_urls(group.incivents)) unless group.incivents.empty?
  group_urlarray.push(tasks_urls(group.tasks)) unless group.tasks.empty?
  group_urlarray.push(messages_urls(group.messages))unless group.messages.empty?
  return group_urlarray.join("%|%")
 end

end
