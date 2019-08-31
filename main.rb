require_relative './train.rb'
require_relative './station.rb'
require_relative './route.rb'
require_relative './passenger_carriage.rb'
require_relative './cargo_carriage.rb'
require_relative './passenger_train.rb'
require_relative './cargo_train.rb'

class MainMenu
  def initialize
    init_text
    @trains = []
    @routes = []
    @stations = []
  end

  def main_menu(command)
    case command
    when '1'
      create_station
    when '2'
      create_train
    when '3'
      create_route
    when '4'
      configure_route
    when '5'
      configure_train
    when '6'
      station_full_info
    when 'help'
      init_text
    when 'exit'
      nil
    else
      puts 'Wrong input! Type "help" for instructions'
    end
  end

  private

  attr_reader :trains, :routes, :stations

  def create_station
    puts 'Enter new station name: '
    print ':> > '
    station_name = gets.chomp
    stations.push(Station.new(station_name))
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_train
    puts 'Enter new train ID: '
    print ':> > '
    train_id = gets.chomp
    puts 'Choose train type: 1 - Passenger, 2 - Cargo  '
    loop do
      print ':> > > '
      user_input = gets.chomp
      case user_input
      when '1'
        trains.push(PassengerTrain.new(train_id))
        break
      when '2'
        trains.push(CargoTrain.new(train_id))
        break
      when 'exit'
        break
      else
        puts 'Wrong input!'
      end
    end
    print_single_train(Train.find(train_id))
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_route
    if stations.size >= 2
      puts "Choose start station (1..#{stations.size})"
      start_station = station_chooser
      puts 'Start'
      puts "  |1.#{start_station.name}"
      puts '  |2. ...'
      puts 'End'
      puts "Choose end station (1..#{stations.size})"
      end_station = station_chooser
      puts 'Start'
      puts "  |1.#{start_station.name}"
      puts "  |2.#{end_station.name}"
      puts 'End'
      routes.push(Route.new(start_station, end_station))
    else
      puts 'Create more stations first!'
    end
  end

  def configure_route
    puts 'Select route ...'
    return unless (selected_route = route_chooser)

    puts "Selected: #{print_single_route(selected_route)}"
    puts 'Command list: '
    puts '1. Add station'
    puts '2. Remove station'
    puts '  (Route cannot be left with less than 2 stations)'
    puts 'exit. for exit'
    loop do
      print ':> > > '
      user_input = gets.chomp
      case user_input
      when '1'
        selected_route.add_station(station_chooser)
        print_single_route(selected_route)
      when '2'
        if selected_route.route_list.size <= 2
          puts 'Route cannot be less than 2 stations!'
        else
          selected_route.remove_station(station_chooser)
          print_single_route(selected_route)
        end
      when 'exit'
        break
      else
        puts 'Wrong input!'
      end
    end
  end

  def configure_train
    puts 'Select train ... '
    return unless (selected_train = train_chooser)

    puts 'Command list: '
    puts '1. Assign route'
    puts '2. Add carriage'
    puts '3. Remove carriage'
    puts '4. Go to the next station'
    puts '5. Go one station back'
    puts '6. Print carriages list'
    puts '7. Take place in carriage'
    puts 'exit. for exit'
    puts 'Selected: '
    loop do
      print_single_train(selected_train)
      print ':> > > '
      user_input = gets.chomp
      case user_input
      when '1'
        selected_train.route = route_chooser unless routes.empty?
      when '2'
        begin
           if selected_train.get_type == 'Passenger'
             puts 'Enter carriage seats count: '
             print ':> > > >'
             seats = gets.chomp.to_i
             selected_train.add_carriage(PassengerCarriage.new(seats))
           elsif selected_train.get_type == 'Cargo'
             puts 'Enter carriage volume: '
             print ':> > > >'
             volume = gets.chomp.to_i
             selected_train.add_carriage(CargoCarriage.new(volume))
           end
        rescue RuntimeError => e
          puts e.message
          retry
         end
      when '3'
        selected_train.remove_carriage
      when '4'
        selected_train.go_next
      when '5'
        selected_train.go_back
      when '6'
        carriages_list(selected_train)
      when '7'
        begin
          current_carriage = carriage_chooser(selected_train)
          next unless current_carriage

          if selected_train.get_type == 'Passenger'
            current_carriage.take_seat
          elsif selected_train.get_type == 'Cargo'
            puts 'Enter cargo volume: '
            print ':> > > > >'
            volume = gets.chomp.to_i
            current_carriage.take_volume(volume)
          end
        rescue RuntimeError => e
          puts e.message
          puts 'Choose carriage again'
          retry
        end
      when 'exit'
        break
      else
        puts 'Wrong input!'
      end
    end
  end

  def station_list
    counter = 0
    stations.each do |station|
      print "#{counter += 1}. "
      puts station.name.to_s
    end
  end

  def route_list
    counter = 0
    routes.each do |route|
      print "#{counter += 1}. "
      print_single_route(route)
    end
  end

  def train_list
    counter = 0
    trains.each do |train|
      print "#{counter += 1}. "
      print_single_train(train)
    end
  end

  def carriages_list(train)
    print_single_train(train)
    carriages_count = 0
    train.each_carriage do |carriage|
      print "#{carriages_count += 1}."
      print_single_carriage(carriage)
    end
  end

  def route_chooser
    if !routes.empty?
      route_list
      loop do
        print ':> > '
        user_input = gets.chomp.to_i
        if routes[user_input - 1] && user_input != 0
          break routes[user_input - 1]
        end
      end
    else
      puts 'No routes was created yet!'
    end
  end

  def station_chooser
    if !stations.empty?
      station_list
      loop do
        print ':> > '
        user_input = gets.chomp.to_i
        if stations[user_input - 1] && user_input != 0
          break stations[user_input - 1]
        end

        puts 'Wrong station number!'
      end
    else
      puts 'No stations was created yet!'
    end
  end

  def train_chooser
    if !trains.empty?
      train_list
      loop do
        print ':> > '
        user_input = gets.chomp.to_i
        if trains[user_input - 1] && user_input != 0
          break trains[user_input - 1]
        end
      end
    else
      puts 'No trains was created yet!'
    end
  end

  def carriage_chooser(train)
    if !train.carriages.empty?
      carriages_list(train)
      loop do
        print ':> > '
        user_input = gets.chomp.to_i
        if train.carriages[user_input - 1] && user_input != 0
          break train.carriages[user_input - 1]
        end
        break if user_input.zero? || user_input == 'exit'
      end
    else
      puts 'No carriages was created yet!'
    end
  end

  def print_single_route(route)
    if route
      route.route_list.each { |station| print "[#{station.name} -> " }
      puts ']'
    else
      puts ' - '
    end
  end

  def print_single_train(train)
    puts " ID: #{train.id}, Type: #{train.get_type}," \
         " Carriages: #{train.carriages_count}"
    print '  Route: '
    print_single_route(train.route)
    print '    Current station: '
    print_single_station(train.current_station)
  end

  def print_single_station(station)
    if station
      puts station.name.to_s
    else
      puts ' - '
    end
  end

  def print_single_carriage(carriage)
    if carriage.type == :passenger_carriage
      puts " №#{carriage.id}; Seats avaible: #{carriage.free_seats};" \
           " Seats taken: #{carriage.taken_seats}"
    elsif carriage.type == :cargo_carriage
      puts " №#{carriage.id}; Volume avaible: #{carriage.free_volume};" \
           " Volume taken: #{carriage.taken_volume}"
    end
  end

  def station_full_info
    if !stations.empty?
      station_counter = 0
      stations.each do |station|
        print "#{station_counter += 1}. "
        puts station.name.to_s
        train_counter = 0
        puts 'Trains on this station: '
        station.each_train do |train|
          print "<<<< #{train_counter += 1}. "
          print_single_train(train)
        end
      end
    else
      puts 'Create at least one station first!'
    end
  end

  def init_text
    puts 'Command list: '
    puts "'1' = Create new station"
    puts "'2' = Create new train"
    puts "'3' = Create new route"
    puts "'4' = Configure route"
    puts "'5' = Configure train"
    puts "'6' = Stations info"
    puts "'help' = print command list"
    puts "'exit' = exit"
  end
=begin
  def seed
    trains.push(CargoTrain.new("1022-1"))
    trains.push(PassengerTrain.new("2244-02b"))
    stations.push(Station.new("Penza gruzovoy-1"))
    stations.push(Station.new("Kharkov"))
    stations.push(Station.new("Moscow, Kievskiy railway"))
    stations.push(Station.new("SPB"))
    routes.push(Route.new(stations[0], stations[1]))
  end
=end
end

menu = MainMenu.new

loop do
  puts 'Main menu:'
  print ':> '
  user_input = gets.chomp
  menu.main_menu(user_input)
  break if user_input == 'exit'
end
