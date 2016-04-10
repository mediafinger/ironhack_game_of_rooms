require 'set'

class Player
  attr_reader :inventory, :killpoints

  def initialize(options = {})
    @inventory = options[:inventory] || Set.new()
    @killpoints = options[:killpoints] || 0
  end

  def self.load(options = {})
    Player.new(
      inventory: options[:inventory].to_set,
      killpoints: options[:killpoints]
    )
  end

  # the player
  def serialize
    {
      inventory: @inventory.to_a,
      killpoints: @killpoints
    }
  end

  def add_to_inventory(item)
    if @inventory.include? item
      puts "You already have a #{item} and you don't need a second."
    else
      puts " + + + #{item.capitalize} added to inventory. + + + "
      @inventory << item
    end
  end

  def remove_from_inventory(item)
    puts " - - - #{item.capitalize} removed from inventory. - - - "
    @inventory.delete_if { |elem| elem == item  }
  end

  def has?(item)
    @inventory.include?(item)
  end

  def add_killpoints(points)
    @killpoints += points
    puts "☠  Adding #{points} killpoints! ☠"
    puts "☠  You have now #{@killpoints} killpoints. ☠"
  end
end
