id = params[:id].present? ? params[:id] : nil

json.array! @libraries do |library|
  if id === library.id.to_s || id.blank?
    json.id library.id
    json.name library.name
  end
end
