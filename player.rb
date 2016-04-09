class Player
  attr_reader :inventory, :killpoints

  def initialize
    @inventory = []
    @killpoints = 0
  end

  def add_to_inventory(item)
    puts "#{item.capitalize} added to inventory."
    @inventory.push(item)
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
