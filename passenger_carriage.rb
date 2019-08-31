require_relative './carriage.rb'

class PassengerCarriage < Carriage
  attr_reader :free_seats, :taken_seats
  attr_accessor :id

  def initialize(seats)
    @free_seats = seats
    validate!
    @taken_seats = 0
    # rubocop:disable Style/ClassVars
    @@id_counter += 1
    # rubocop:enable Style/ClassVars
    @id = @@id_counter
  end

  def take_seat
    raise 'No free seats available!' unless free_seats.positive?

    self.free_seats -= 1
    self.taken_seats += 1
  end

  def type
    :passenger_carriage
  end

  protected

  attr_writer :free_seats, :taken_seats

  def validate!
    validate_seats!
  end

  def validate_seats!
    raise 'Wrong seats count!' unless free_seats >= 0
  end
end
