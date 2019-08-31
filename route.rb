require_relative './instance_counter.rb'
require_relative './validation.rb'
require_relative './accessors.rb'
require_relative './station.rb'

class Route
  include InstanceCounter
  include Validation
  extend Accessors

  attr_accessor_with_history :route_list 

  validate :first_station, :type, Station
  validate :last_last, :type, Station

  puts @validations[0][:arg].class
  def initialize(first, last)
    @first_station = first 
    @last_station = last 
    @route_list = [first, last]
    validate!
    self.class.register_instance
  end

  def add_station(station)
    route_list.push(station)
  end

  def remove_station(station)
    route_list.delete(station) if route_list.size > 2
  end

end
