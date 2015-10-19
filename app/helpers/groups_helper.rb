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
  group_latarray.push(incivents_lats(group.incivents.unarchived)) unless group.incivents.unarchived.empty?
  group_latarray.push(measurements_lats(group.measurements.unarchived)) unless group.measurements.unarchived.empty?
  group_latarray.push(tasks_lats(group.tasks.unarchived)) unless group.tasks.unarchived.empty?
  group_latarray.push(stories_lats(group.stories.unarchived)) unless group.stories.unarchived.empty?
  return group_latarray.join("%|%")
 end

 def group_longs(group)
  group_longarray = []
  group_longarray.push(incivents_longs(group.incivents.unarchived)) unless group.incivents.unarchived.empty?
  group_longarray.push(measurements_longs(group.measurements.unarchived)) unless group.measurements.unarchived.empty?
  group_longarray.push(tasks_longs(group.tasks.unarchived)) unless group.tasks.unarchived.empty?
  group_longarray.push(stories_longs(group.stories.unarchived)) unless group.stories.unarchived.empty?
  return group_longarray.join("%|%")
 end

 def group_feature_names(group)
  group_namearray = []
  group_namearray.push(incivents_names(group.incivents.unarchived)) unless group.incivents.unarchived.empty?
  group_namearray.push(measurements_names(group.measurements.unarchived)) unless group.measurements.unarchived.empty?
  group_namearray.push(tasks_names(group.tasks.unarchived)) unless group.tasks.unarchived.empty?
  group_namearray.push(stories_names(group.stories.unarchived)) unless group.stories.unarchived.empty?
  return group_namearray.join("%|%")
 end

 def group_feature_urls(group)
  group_urlarray = []
  group_urlarray.push(incivents_urls(group.incivents.unarchived)) unless group.incivents.unarchived.unarchived.empty?
  group_urlarray.push(measurements_urls(group.measurements.unarchived)) unless group.measurements.unarchived.unarchived.empty?
  group_urlarray.push(tasks_urls(group.tasks.unarchived)) unless group.tasks.unarchived.unarchived.empty?
  group_urlarray.push(stories_urls(group.stories.unarchived))unless group.stories.unarchived.unarchived.empty?
  return group_urlarray.join("%|%")
 end

end
