json.array! @departments do |department|
    json.id department.id
    json.name department.name
    json.description department.description
    json.library_id department.library_id
end
