require 'json'
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
    @food = 2  # for the Hunger module
    @map = Map.new(@player)
    @current_room = @map.setup
  end

  def start
    puts "Let the game begin..."
    puts "~" * 64
    room_description
  end

  def self.game_over
    puts "~" * 64
    puts " G A M E  ☠   O V E R "
    exit
  end

  private

  # the player, the food, the rooms and actions
  def serialize
    { current_room: @current_room.identifier, food: @food }.merge(@player.serialize).merge(@map.serialize)
  end

  def game_over
    Game.game_over
  end

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

    puts "---> You can go: #{exits.join(', ')}"
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
      puts "You scream for help, but you are alone."
      puts "Type 'INSPECT ROOM' to investigate a room"
      puts "or type 'SAVE' to save your game and 'LOAD' to load one"
      puts "or type 'QUIT' if you want to leave."
    when "N", "NORTH", "W", "WEST", "S", "SOUTH", "E", "EAST"
      direction = DIRECTIONS[command[0]]
      @current_room.exit_to(direction) ? move(direction) : error(direction)
    when "L", "F", "LOOK FOR FOOD", "FOOD", "FIND FOOD"
      look_for_food # defined in module Hunger
    when "I", "INSPECT", "INSPECT ROOM", "INVESTIGATE", "INVESTIGATE ROOM"
      @current_room.trigger_action
    when "INVENTORY", "MY STUFF"
      puts "You carry: #{@player.inventory.to_a.join(', ')}"
    when "SAVE", "SAVE GAME"
      save_game
    when "LOAD", "LOAD GAME"
      load_game
    when "Q", "QUIT"
      puts "~" * 64
      puts "☠  You achieved exactly #{@player.killpoints} killpoints! ☠"
      puts " * * * Goodbye! * * * "
      game_over
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

  def save_game
    puts "This will overwrite any existing savegame. Continue? (Yes / No)"
    print "> "
    choice = gets.chomp.upcase[0]

    if choice == "Y"
      File.open("./savegame.json", mode: "w") do |file|
        file << serialize.to_json
      end

      puts "Your game has been saved. ✓"
    end
  end

  def load_game
    puts "You will lose all current progress when you load the savegame. Continue? (Yes / No)"
    print "> "
    choice = gets.chomp.upcase[0]

    if choice == "Y"
      file = File.read("./savegame.json") # TODO handle missing file
      serialized_hash = JSON.parse(file)

      @food = serialized_hash["food"]

      @player = Player.load(
        inventory: serialized_hash["inventory"],
        killpoints: serialized_hash["killpoints"]
      )

      @map = Map.new(@player)
      rooms = @map.load(serialized_hash["rooms"])
      room = rooms.values.find { |room| room.identifier == serialized_hash["current_room"] }
      @current_room = room
    end

    puts "Loading successful. ✓"
    room_description
  end
end
