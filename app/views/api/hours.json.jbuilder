json.array! @hours do |hour|
  json.(hour, :name, :date, :open_time, :close_time, :comment)
end
