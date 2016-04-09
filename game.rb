require_relative "./hunger.rb"
require_relative "./room.rb"

class Game
  include Hunger

  DIRECTIONS = {
    "N" => :north,
    "E" => :east,
    "S" => :south,
    "W" => :west,
  }

  def initialize
    setup

    start
  end

  private

  def start(current_room = @dark_room)
    @current_room = current_room

    puts "Let the games begin..."
    puts " -  " * 10
    prompt
  end

  def prompt
    puts @current_room.description
    print_exits

    print "> "

    input
  end

  def print_exits
    exits = @current_room.exits.map do |direction, _room|
      direction.to_s.capitalize
    end

    puts "Exits: #{exits.join(', ')}"
  end

  def input
    direction = gets.chomp.upcase[0]
    dir = DIRECTIONS[direction] || direction

    case dir
    # when a, b, c behaves like if a || b || c
    when :north, :east, :south, :west
      @current_room.exit_to(dir) ? move(dir) : error(dir)
    when "L"
      look_for_food # defined in module Hunger
    when "Q"
      puts "Goodbye!"
      exit
    else
      puts "I don't understand. If you want to leave press 'Q'"
    end

    prompt
  end

  def move(direction)
    puts "You go #{direction}."
    @current_room = @current_room.exit_to(direction)
  end

  def error(direction)
    puts "You can not go #{direction.to_s}."
  end

  def setup
    create_rooms
    create_connections
  end

  def create_rooms
    @dark_room = Room.new("You are in a dark room.")
    @bear_room = Room.new("You are in the forest. There is a lot of light. There is a bear sleeping.")
    @lake_room = Room.new("You are at a lake.")
    @chest_room = Room.new("You are in a small room. In front of you is a chest")
    @crossing = Room.new("You are at a crossing.")
  end

  def create_connections
    @dark_room.add_exit(:north, @crossing)
    @crossing.add_exit(:south, @dark_room)

    @lake_room.add_exit(:south, @crossing)
    @crossing.add_exit(:north, @lake_room)

    @lake_room.add_exit(:west, @bear_room)
    @bear_room.add_exit(:east, @lake_room)

    @chest_room.add_exit(:east, @crossing)
    @crossing.add_exit(:west, @chest_room)
  end
end
