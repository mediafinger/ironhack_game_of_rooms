class Action
  def initialize(player, options = {})
    @player = player  # to check and add to inventory, to add killpoints

    @type = options[:type]
    @thing = options[:thing]

    @confirmation = options[:confirmation]
    @failure = options[:failure]

    @item = options[:item]
    @remove = options[:remove]
  end

  # just the action
  def serialize
    {
      confirmation: @confirmation,
      failure: @failure,
      item: @item,
      remove: @remove,
      thing: @thing,
      type: @type,
    }
  end

  def trigger
    puts "You see a #{@thing}. Do you want to #{@type} it? (Yes / No)"
    print "> "
    choice = gets.chomp.upcase[0]

    action if choice == "Y"
  end

  private

  def action
    case @type
    when "open"
      open_thing
    when "push"
      push_thing
    when "take"
      take_thing
    when "kill"
      kill_enemy
    when "interact with"
      interact_with_thing
    end
  end

  # 85% chance to get item
  # 15% chance to die
  def open_thing
    if rand(0..5) > 0
      puts @confirmation
      @player.add_to_inventory(@item)
    else
      puts @failure
      Game.game_over
    end
  end

  # 15% chance to get item
  # 15% chance to die
  def push_thing
    random = rand(0..5)

    if random == 5
      puts @confirmation
      @player.add_to_inventory(@item)
    elsif random > 0
      puts @confirmation
    else
      puts @failure
      Game.game_over
    end
  end

  # 100% chance to get item
  # 0% chance to die
  def take_thing
    puts @confirmation
    @player.add_to_inventory(@thing)
  end

  # 100% chance to kill enemy if player has the right item
  # 100% chance to die if player does not have the right item
  def kill_enemy
    if @player.has?(@item)
      puts @confirmation
      @player.remove_from_inventory(@remove) if @remove
      points = @thing.chars.reduce(0) { |sum, c| sum + c.getbyte(0) }
      @player.add_killpoints(points)
    else
      puts @failure
      Game.game_over
    end
  end

  # 33% chance to get thing if player is friendly
  # 15% chance to get item if player is unfriendly
  # 0% chance to die
  def interact_with_thing
    random = rand(0..5)

    puts "Do you want to be friendly? (Yes / No)"
    print "> "
    choice = gets.chomp.upcase[0]

    if choice == "Y"
      if random > 3
        puts @confirmation
        @player.add_to_inventory(@thing)
      elsif random > 1
        puts @confirmation
      else
        puts @failure
      end
    else
      if random == 5
        puts @confirmation
        @player.add_to_inventory(@item)
      elsif random > 3
        puts @confirmation
      else
        puts @failure
      end
    end
  end
end
