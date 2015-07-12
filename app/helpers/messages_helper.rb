module StoriesHelper

   # Concatinate the arrays of information, longtitudes and latitudes for sending to Google Maps
 def stories_lats(stories)
  latarray = []
  stories.each do |story|
    latarray.push(story.latitude)
  end
  return latarray.join('%|%')
 end

 def stories_longs(stories)
  longarray = []
  stories.each do |story|
    longarray.push(story.longitude)
  end
  return longarray.join('%|%')
 end

 def stories_names(stories)
  namearray = []
  stories.each do |story|
    namearray.push("<div class='label-story'><strong>Story</strong></div>
                    <div class='label-content'>#{truncate(story.description, length: 55)}</div>
                    <div class='label-footer'>Posted by: #{story.user.full_name}<br />Date: #{time_ago_in_words(story.created_at)} ago</div>")
  end
  return namearray.join('%|%')
 end

 def stories_urls(stories)
  urlarray = []
  stories.each do |story|
    urlarray.push(story_url(story))
  end
  return urlarray.join('%|%')
 end


end
