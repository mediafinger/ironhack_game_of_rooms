require_relative "./room.rb"

class Game
  DIRECTIONS = {
    "N" => :north,
    "E" => :east,
    "S" => :south,
    "W" => :west,
  }

  def initialize
    setup

    @current_room = @dark_room

    puts "Let the games begin..."
    prompt
  end

  def prompt
    puts @current_room.description
    print "> "

    input
  end

  def input
    direction = gets.chomp.upcase[0]
    dir = DIRECTIONS[direction] || direction

    case dir
    # when a, b, c behaves like if a || b || c
    when :north, :east, :south, :west
      @current_room.exit_to(dir) ? move(dir) : error(dir)
    when "Q"
      exit
    else
      puts "I don't understand. If you want to leave press 'Q'"
      prompt
    end
  end

  def move(direction)
    puts "You go #{direction}."
    @current_room = @current_room.exit_to(direction)
    prompt
  end

  def error(direction)
    puts "You can not go #{direction.to_s}."
    prompt
  end

  private

  def setup
    create_rooms
    create_connections
  end

  def create_rooms
    @dark_room = Room.new("You are in a dark room. There is a door to the north.")
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
