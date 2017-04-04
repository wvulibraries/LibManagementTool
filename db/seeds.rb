# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([[ name: 'Star Wars' ], [ name: 'Lord of the Rings' ]])
#   Character.create(name: 'Luke', movie: movies.first)

libs = [
  [ "Downtown Campus Library", "Main campus located in downtown Morgantown."],
  [ "Evansdale Library", "Evansdale library more suited to majors on the Evandale campus."],
  [ "Health Sciences Library (Charleston)", "HSC"],
  [ "Health Sciences Library", "Library associated with the health sciences and focusing on medical care."],
  [ "Mary F. Shipper Library (Potomac State)", "PSC library located on PSC campus."],
  [ "Law Library", "Legal Library"],
  [ "Vining Library (Institute of Technology)", " "]
]

libs.each do |name, desc|
  Library.create(name: name, description: desc)
end


depts = [
  ["Access Services", "Helps accessing of material.", 1],
  ["Access Services", "Helps accessing of material.", 2],
  ["Research Services", "Helps students research. ", 2],
  ["Research Services", "Helps students research. ", 1],
  ["Research Services", "Helps students research. ", 3],
  ["Eliza's Coffee Shop",  "Food, Coffee, Anime.", 1],
  ["DaVinci's Cafe",  "Coffee. Food. Snacks.", 2],
  ["Multimedia Services","",1],
  ["Multimedia Services","",2],
  ["WV Regional History Center", "Historical preservation and digital finding aids.", 1]
]

depts.each do |name, desc, lib|
  Department.create(name:name, description: desc, library_id: lib)
end

start_time = Time.now
end_time = Time.now + 10*60*60

normal_hours = [
  ['department', 1, 1, start_time, end_time],
  ['department', 1, 2, start_time, end_time],
  ['department', 1, 3, start_time, end_time],
  ['department', 1, 4, start_time, end_time],
  ['department', 1, 5, start_time, end_time],
  ['department', 1, 6, start_time, end_time],
  ['department', 1, 0, nil, nil],
  ['library', 1, 1, nil, nil],
  ['library', 1, 2, start_time, end_time],
  ['library', 1, 3, start_time, end_time],
  ['library', 1, 4, start_time, end_time],
  ['library', 1, 5, start_time, end_time],
  ['library', 1, 6, start_time, end_time],
  ['library', 1, 0, nil, nil]
]

normal_hours.each do | rtype, rid, day, open_time, close_time |
  NormalHour.create(resource_type: rtype, resource_id: rid, day_of_week: day, open_time: open_time, close_time: close_time)
end

# Create Users
User.create(username: 'djdavis', firstname: 'David', lastname: 'Davis', admin: true)
User.create(username: 'tam0013', firstname: 'Tracy', lastname: 'McCormick', admin: true)
