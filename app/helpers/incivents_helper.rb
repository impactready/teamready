module InciventsHelper

   # Concatinate the arrays of information, longtitudes and latitudes for sending to Google Maps
 def incivents_lats(incivents)
  latarray = []
  incivents.each do |incivent|
    latarray.push(incivent.latitude)
  end
  return latarray.join("%|%")
 end

 def incivents_longs(incivents)
  longarray = []
  incivents.each do |incivent|
    longarray.push(incivent.longitude)
  end
  return longarray.join("%|%")
 end

 def incivents_names(incivents)
  namearray = []
  incivents.each do |incivent|
    namearray.push("<div class='label-incivent'><strong>Event</strong></div>
                    <div class='label-content'>#{truncate(incivent.description, length: 55)}</div>
                    <div class='label-footer'>Posted by: #{incivent.user.full_name}<br />Date: #{time_ago_in_words(incivent.created_at)} ago</div>")
  end
  return namearray.join("%|%")
 end

 def incivents_urls(incivents)
  urlarray = []
  incivents.each do |incivent|
    urlarray.push(incivent_url(incivent))
  end
  return urlarray.join("%|%")
 end

end
