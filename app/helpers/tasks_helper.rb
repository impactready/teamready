module TasksHelper

   # Concatinate the arrays of ninformation, longtitudes and latitudes for sending to Google Maps
 def tasks_lats(tasks)
  latarray = []
  tasks.each do |task|
    latarray.push(task.latitude)
  end
  return latarray.join('%|%')
 end

 def tasks_longs(tasks)
  longarray = []
  tasks.each do |task|
    longarray.push(task.longitude)
  end
  return longarray.join('%|%')
 end

 def tasks_names(tasks)
  namearray = []
  tasks.each do |task|
    task_status = task.complete? ? 'Completed' : "Due: #{task.due_date}"
    namearray.push("<div class='label-task'><strong>Task</strong></div>
                    <div class='label-content'>#{truncate(task.description, length: 55)}</div>
                    <div class='label-footer'>Assigned to: #{task.user.full_name}<br />#{task_status}</div>")
  end
  return namearray.join('%|%')
 end

 def tasks_urls(tasks)
  urlarray = []
  tasks.each do |task|
    urlarray.push(task_url(task))
  end
  return urlarray.join('%|%')
 end


end
