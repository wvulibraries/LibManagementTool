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
  [ "Health Sciences Library", "Library associated with the health sciences and focusing on medical care."],
  [ "Potomac State College Library", "PSC library located on PSC campus."],
]

libs.each do |name, desc|
  Library.create(name:name, description: desc)
end


depts = [
  ["Access Services", "Helps students access stuff like research material.", 1],
  ["Eliza's Coffee Shop",  "Food, Coffee, Anime.", 1],
  ["Access Services", "Helps students find research stuff.", 2]
]

depts.each do |name, desc, lib|
  Department.create(name:name, description: desc, library_id: lib)
end
