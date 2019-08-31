require_relative './instance_counter.rb'
require_relative './instance_list.rb'
require_relative './company_info.rb'

class Train
  include CompanyInfo
  include InstanceList
  include InstanceCounter

  attr_reader :id, :route, :carriages

  def initialize(id)
    @id = id
    validate!
    @carriages = []
    self.class.register_instance
    register_instance_in_list
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def self.find(id)
    instance_list.select { |train| train.id == id }.first
  end

  def route=(route)
    current_station.depart_train(self) if self.route
    @route = route
    self.current_station_index = 0
    current_station.accept_train(self)
  end

  def each_carriage
    carriages.each { |carriage| yield carriage }
  end

  def current_station
    route.route_list[current_station_index] if route
  end

  def next_station
    return unless route &&
                  current_station_index + 1 < route.route_list.size

    route.route_list[current_station_index + 1]
  end

  def prev_station
    return unless route && current_station_index.positive?

    route.route_list[current_station_index + -1]
  end

  def remove_carriage
    carriages.pop
  end

  def add_carriage(carriage)
    carriages.push(carriage)
  end

  def carriages_count
    carriages.size
  end

  def go_next
    self.current_station_index += 1 if go(next_station)
  end

  def go_back
    self.current_station_index -= 1 if go(prev_station)
  end

  protected

  VALID_ID = /^ \w{3} (|-\w{2}) $/x.freeze

  attr_accessor :current_station_index

  def validate!
    validate_train_id!
  end

  def validate_train_id!
    raise 'invalid train id!' unless id =~ VALID_ID
  end

  def go(station)
    return unless station

    current_station.depart_train(self)
    station.accept_train(self)
  end
end
