require_relative './instance_list.rb'
require_relative './instance_counter.rb'

class Station
  include InstanceList
  include InstanceCounter
  extend Accessors

  attr_reader :trains
  attr_accessor_with_history :name

  def initialize(name)
    @name = name
    @trains = []
    validate!
    self.class.register_instance
    register_instance_in_list
  end

  def self.all
    instance_list
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def each_train
    trains.each { |train| yield train }
  end

  def trains_by_type(type)
    trains.collect { |train| train if train.type == type }
  end

  def accept_train(train)
    trains.push(train) unless trains.include?(train)
  end

  def depart_train(train)
    trains.delete(train) if trains.include?(train)
  end

  protected

  def validate!
    validate_name!
  end

  def validate_name!
    raise 'invalid station name!' if name !~ /.{2,}/
  end
end
