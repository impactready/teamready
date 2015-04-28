module MessagesHelper

   # Concatinate the arrays of ninformation, longtitudes and latitudes for sending to Google Maps
 def messages_lats(messages)
  latarray = []
  messages.each do |message|
    latarray.push(message.latitude)
  end
  return latarray.join('%|%')
 end

 def messages_longs(messages)
  longarray = []
  messages.each do |message|
    longarray.push(message.longitude)
  end
  return longarray.join('%|%')
 end

 def messages_names(messages)
  namearray = []
  messages.each do |message|
    namearray.push("<div class='label-message'><strong>Message</strong></div>
                    <div class='label-content'>#{truncate(message.description, length: 55)}</div>
                    <div class='label-footer'>Posted by: #{message.user.full_name}<br />Date: #{time_ago_in_words(message.created_at)} ago</div>")
  end
  return namearray.join('%|%')
 end

 def messages_urls(messages)
  urlarray = []
  messages.each do |message|
    urlarray.push(message_url(message))
  end
  return urlarray.join('%|%')
 end


end
