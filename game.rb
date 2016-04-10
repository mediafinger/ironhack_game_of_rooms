require_relative "./hunger.rb"
require_relative "./room.rb"
require_relative "./player.rb"
require_relative "./action.rb"
require_relative "./map.rb"

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

    start
  end

  private

  def start
    puts "Let the game begin..."
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
    print_locked_exits
  end

  def print_locked_exits
    locked_exits = @current_room.exits.map do |direction, _room|
      [direction, direction.to_s.capitalize] if @current_room.locked?(direction)
    end

    unless locked_exits.compact!.empty?
      puts "You investigate the doors and realize these are locked: #{locked_exits.map(&:last).join(', ')}"

      if @player.inventory.include? "key"
        locked_exits.map(&:first).each { |dir| @current_room.unlock(dir) }
        puts "You use your key 🔑  to unlock a door: #{locked_exits.map(&:last).join(', ')}"
        # TODO: remove key from inventory? OR: create specific keys for every door?
      end
    end
  end

  def input
    command = gets.chomp.upcase
    action = DIRECTIONS[command[0]] || command

    case action
    # when a, b, c behaves like if a || b || c
    when :north, :east, :south, :west
      @current_room.exit_to(action) ? move(action) : error(action)
    when "L", "LOOK FOR FOOD"
      look_for_food # defined in module Hunger
    when "I", "INSPECT ROOM"
      @current_room.action.trigger
    when "Q"
      puts "☠  You achieved exactly #{@player.killpoints} killpoints! ☠"
      puts " * * * Goodbye! * * * "
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
end
