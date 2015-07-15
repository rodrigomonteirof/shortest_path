# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Map.new(name: 'SIMPLE').save
m = Map.find_by(name: 'SIMPLE')

Route.new(map: m, origin: 'A', destiny: 'B', distance: 10).save
Route.new(map: m, origin: 'B', destiny: 'D', distance: 15).save
Route.new(map: m, origin: 'A', destiny: 'C', distance: 20).save
Route.new(map: m, origin: 'C', destiny: 'D', distance: 30).save
Route.new(map: m, origin: 'B', destiny: 'E', distance: 50).save
Route.new(map: m, origin: 'D', destiny: 'E', distance: 30).save
