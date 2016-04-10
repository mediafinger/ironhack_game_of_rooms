require_relative "./action.rb"
require_relative "./hunger.rb"
require_relative "./map.rb"
require_relative "./player.rb"
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
    @player = Player.new
    @current_room = Map.new(@player).setup
  end

  def start
    puts "Let the game begin..."
    puts "~" * 64
    room_description
  end

  private

  def room_description
    puts @current_room.description
    print_exits

    prompt
  end

  def prompt
    print "> "
    input
  end

  def print_exits
    exits = @current_room.exits.map do |direction, _room|
      direction.to_s.capitalize
    end

    puts "Exits: #{exits.join(', ')}"
    print_locked_exits
  end

  def print_locked_exits
    locked_exits = @current_room.exits.map do |direction, _room|
      [direction, direction.to_s.capitalize] if @current_room.locked?(direction)
    end

    unless locked_exits.compact!.empty?
      puts "You investigate the doors and realize these are locked: #{locked_exits.map(&:last).join(', ')}"

      if @player.has? "key"
        locked_exits.map(&:first).each { |dir| @current_room.unlock(dir) }
        puts "You use your key 🔑  to unlock a door: #{locked_exits.map(&:last).join(', ')}"
        @player.remove_from_inventory("key")
        # TODO: remove key from inventory? OR: create specific keys for every door?
      end
    end
  end

  def input
    command = gets.chomp.upcase

    case command
    when "H", "HELP"
      puts "You scream for help, but you are alone.\nType 'INSPECT ROOM' to investigate a room\nor 'QUIT' if you want to leave."
    when "N", "NORTH", "W", "WEST", "S", "SOUTH", "E", "EAST"
      direction = DIRECTIONS[command[0]]
      @current_room.exit_to(direction) ? move(direction) : error(direction)
    when "L", "LOOK FOR FOOD"
      look_for_food # defined in module Hunger
    when "I", "INSPECT", "INSPECT ROOM", "INVESTIGATE", "INVESTIGATE ROOM"
      @current_room.trigger_action
    when "INVENTORY", "MY STUFF"
      puts "You carry: #{@player.inventory.to_a.join(', ')}"
    when "Q", "QUIT"
      puts "☠  You achieved exactly #{@player.killpoints} killpoints! ☠"
      puts " * * * Goodbye! * * * "
      exit
    else
      puts "I don't understand."
    end

    prompt
  end

  def move(direction)
    puts "You go #{direction}."
    @current_room = @current_room.exit_to(direction)
    puts " -  " * 16
    room_description
  end

  def error(direction)
    puts "You can not go #{direction.to_s}."
  end
end
