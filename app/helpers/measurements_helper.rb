module MeasurementsHelper

   # Concatinate the arrays of information, longtitudes and latitudes for sending to Google Maps
 def measurements_lats(measurements)
  latarray = []
  measurements.each do |measurement|
    latarray.push(measurement.latitude)
  end
  return latarray.join("%|%")
 end

 def measurements_longs(measurements)
  longarray = []
  measurements.each do |measurement|
    longarray.push(measurement.longitude)
  end
  return longarray.join("%|%")
 end

 def measurements_names(measurements)
  namearray = []
  measurements.each do |measurement|
    namearray.push("<div class='label-measurement'><strong>Measurement</strong></div>
                    <div class='label-content'>#{truncate(measurement.description, length: 55)}</div>
                    <div class='label-footer'>Posted by: #{measurement.user.full_name}<br />Date: #{time_ago_in_words(measurement.created_at)} ago</div>")
  end
  return namearray.join("%|%")
 end

 def measurements_urls(measurements)
  urlarray = []
  measurements.each do |measurement|
    urlarray.push(measurement_url(measurement))
  end
  return urlarray.join("%|%")
 end

end
