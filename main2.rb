require_relative './route.rb'
require_relative './station.rb'
require_relative './train.rb'
#Exception will be raised if first and last is not stations 
#route1 = Route.new("abc", :bca)
route2 = Route.new(Station.new("abc"), Station.new("bca"))
#Incorrect train id 
#train1 = Train.new("223-23v")
train2 = Train.new("322-3v")

station1 = Station.new("abc")
station1.name = "bca"
station1.name = "bcas"
puts station1.name_history
