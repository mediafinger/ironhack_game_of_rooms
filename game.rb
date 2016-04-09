require_relative "./room.rb"

class Game
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
    dir = gets.chomp.upcase[0]

    case dir
    when "N"
      @current_room.north ? move(:north) : error(:north)
    when "E"
      @current_room.east ? move(:east) : error(:east)
    when "S"
      @current_room.south ? move(:south) : error(:south)
    when "W"
      @current_room.west ? move(:west) : error(:west)
    when "Q"
      exit
    else
      puts "I don't understand. If you want to leave press 'Q'"
      prompt
    end
  end

  def move(direction)
    @current_room = @current_room.public_send(direction)
    prompt
  end

  def error(direction)
    puts "You can not go to the #{direction.to_s}."
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
    @dark_room.north = @crossing
    @crossing.south = @dark_room

    @lake_room.south = @crossing
    @crossing.north = @lake_room

    @lake_room.west = @bear_room
    @bear_room.east = @lake_room

    @chest_room.east = @crossing
    @crossing.west = @chest_room
  end
end
