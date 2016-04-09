class Room
  attr_reader :description

  def initialize(description)
    @description = description
    @locked_direction = false
    @exits = {}
  end

  def add_exit(direction, room)
    @exits[direction] = room
  end

  def exit_to(direction)
    if @locked_direction == direction
      puts "This door is locked."
    else
      @exits[direction]
    end
  end

  def exits
    @exits.keys
  end

  def lock(direction)
    @action.room = self
    @locked_direction = direction
  end

  def unlock!
    @locked_direction = false
  end

  def locked?
    @locked_direction && true
  end

  def add_action(action)
    @action = action
  end

  def action
    @action
  end
end
