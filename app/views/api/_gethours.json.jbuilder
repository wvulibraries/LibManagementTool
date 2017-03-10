# count = 0
# limit = params[:limit].present? ? params[:limit] : nil

id = params[:id].present? ? params[:id] : nil
type = params[:type].present? ? params[:type] : nil

#json.array! @hours do |hours|
   #if ad.send_to_JSON
     #count += 1
  #   json.key_format! camelize: :lower
     #json.resource_id normal_hours.resource_id


  #   json.name ad.image_name
  #   json.image_ad request.base_url + url_for(:controller => "display", :action => "show", :id => ad.id)
  #   json.priority ad.priority
  #   json.alt_text ad.alttext
  #   json.action_URL ad.link
   #end

  #  if !limit.nil? && count === limit
  #    break
  #  end

#end

json.array! @normal_hours do |hours|
  # if query strings are nil then it lists all hours
  # this may change later
  
  if id.nil? && type.nil?
    json.id hours.id
    json.resource_type hours.resource_type
    json.resource_id hours.resource_id
    json.day_of_week hours.day_of_week
    json.open_time hours.open_time
    json.close_time hours.close_time
  end
end
