require_relative './instance_counter.rb'

class Route
  include InstanceCounter

  attr_reader :route_list

  def initialize(first, last)
    @route_list = [first, last]
    validate!
    self.class.register_instance
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def add_station(station)
    route_list.push(station)
  end

  def remove_station(station)
    route_list.delete(station) if route_list.size > 2
  end

  protected

  def validate!
    validate_start_end_station!
  end

  def validate_start_end_station!
    raise 'Invalid station in route!' unless route_list[0] && route_list[1]
  end
end
