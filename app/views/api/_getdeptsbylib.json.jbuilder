library_id = params[:library_id].present? ? params[:library_id] : nil
json.array! @departments do |department|
  if library_id == department.library_id.to_s || library_id.blank?
    json.id department.id
    json.name department.name
    json.description department.description
    json.library_id department.library_id
  end
end
