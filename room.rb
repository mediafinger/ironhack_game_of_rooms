class Room
  attr_reader :description

  def initialize(description)
    @description = description
    @exits = {}
  end

  def add_exit(direction, room)
    @exits[direction] = room
  end

  def exit_to(direction)
    @exits[direction]
  end

  def exits
    @exits.keys
  end
end
