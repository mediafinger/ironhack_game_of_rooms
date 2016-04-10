require 'digest/bubblebabble'
require 'set'

class Room
  attr_reader :description, :identifier

  def initialize(description, identifier = nil)
    @description = description
    @exits = {}
    @locked_doors = Set.new()
    @identifier = identifier || Digest::SHA256.bubblebabble(@description)[0..16].to_sym
  end

  # room, connection to other rooms and action
  def serialize
    serialized_exits = {}
    @exits.each do |direction, room|
      serialized_exits[direction] = room.identifier
    end

    {
      identifier: @identifier,
      description: @description,
      exits: serialized_exits,
      locked_doors: @locked_doors.to_a,
      action: @action ? @action.serialize : nil,
    }
  end

  def add_exit(direction, room)
    @exits[direction] = room
  end

  def exit_to(direction)
    if @locked_doors.include? direction
      puts "This door is locked."
    else
      @exits[direction]
    end
  end

  def exits
    @exits.keys
  end

  def lock(direction)
    @locked_doors << direction if exits.include?(direction)
  end

  def unlock(direction)
    @locked_doors.delete_if { |dir| dir == direction  }
  end

  def locked?(direction)
    @locked_doors.include? direction
  end

  def add_action(action)
    @action = action
  end

  def trigger_action
    @action.trigger if @action
  end
end
