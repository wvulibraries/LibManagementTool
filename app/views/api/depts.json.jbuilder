id = params[:id].present? ? params[:id] : nil
json.array! @departments do |department|
  if id == department.id.to_s || id.blank?
    json.id department.id
    json.name department.name
    json.description department.description
    json.library_id department.library_id
  end
end
