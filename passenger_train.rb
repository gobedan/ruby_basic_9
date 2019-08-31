require_relative './train.rb'

class PassengerTrain < Train
  def add_carriage(carriage)
    super if carriage.type == valid_type
  end

  def type
    'Passenger'
  end

  private

  def valid_type
    :passenger_carriage
  end
end
