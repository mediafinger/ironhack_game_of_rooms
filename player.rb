require 'set'

class Player
  attr_reader :inventory, :killpoints

  def initialize
    @inventory = Set.new()
    @killpoints = 0
  end

  def add_to_inventory(item)
    if @inventory.include? item
      puts "You already have a #{item} and you don't need a second."
    else
      puts "#{item.capitalize} added to inventory."
      @inventory << item
    end
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
