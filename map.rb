class Map
  def initialize(player)
    @player = player  # needed to pass into the actions
  end

  # all rooms including the actions and the connection to other rooms
  def serialize
    rooms = {}
    @rooms.each do |key, room|
      rooms[key] = room.serialize
    end

    { rooms: rooms }
  end

  def setup
    create_rooms
    create_actions
    create_connections

    @rooms[:dark_room]  # return the first room, in which the player starts
  end

  def load(saved_rooms)
    @rooms = {}
    saved_rooms.each do |name, data|
      room = Room.new(data["description"], data["identifier"])

      if data["action"]
        room.add_action(
          Action.new(@player,
            :confirmation => data["action"]["confirmation"],
            :failure => data["action"]["failure"],
            :item => data["action"]["item"],
            :remove => data["action"]["remove"],
            :thing => data["action"]["thing"],
            :type => data["action"]["type"],
          )
        )
      end

      @rooms[name.to_sym] = room
    end

    saved_rooms.each do |name, data|
      data["exits"].each do |direction, identifier|
        room = @rooms.values.find { |r| r.identifier == identifier }
        @rooms[name.to_sym].add_exit(direction.to_sym, room)
      end
    end

    saved_rooms.each do |name, data|
      data["locked_doors"].each do |direction|
        @rooms[name.to_sym].lock(direction.to_sym)
      end
    end

    @rooms
  end

  private

  def create_rooms
    @rooms = {
      dark_room: Room.new("You are in a dark room. You can barely see anything."),
      spider_room: Room.new("You are in a dark room. You can barely see anything. Something is hanging from the ceiling. It feels like silk... but sticky."),
      key_room: Room.new("You enter a dimly lit room full of stuff. You are sure you can find something useful."),
      bear_room: Room.new("You open a cage. It smells. Something is lying in the corner."),
      skeleton_room: Room.new("You open a cage. Some bones are hanging in chains from the ceiling."),
      toilet: Room.new("Your nose is convinced you found the bathroom. Not the cleanest though."),
      chest_room: Room.new("After passing through a long hallway you enter a small chamber with massive stone walls."),
      staircase: Room.new("You found a staircase. There are narrow stairs in various directions."),
    }
  end

  def create_actions
    @open_chest = Action.new(@player,
      :type => "open", :thing => "chest", :item => "sword",
      :confirmation => "You found a ⚔  sword ⚔  inside the chest.",
      :failure => "You triggered a trap and are 🔥  burned alive 🔥."
    )

    @push_button = Action.new(@player,
      :type => "push", :thing => "button", :item => "sword",
      :confirmation => "You push the button and some stones slide aside to reveal a small opening. █",
      :failure => "You push the button hard, the ground opens to a bottomless hole 🕳  and you fall inside. And fall. And fall..."
    )

    @take_key = Action.new(@player,
      :type => "take", :thing => "key",
      :confirmation => "You pick up the key 🔑. It is so beautiful.",
    )

    @kill_bear = Action.new(@player,
      :type => "kill", :thing => "bear", :item => "sword",
      :confirmation => "You swing your ⚔  sword ⚔  like Captain Jack Sparrow and slice the bear in 4 parts!",
      :failure => "You attack the bear. The 🐻  is stronger than you ...if you only had a sword. The bear eats you alive."
    )

    @kill_skeleton = Action.new(@player,
      :type => "kill", :thing => "animated skeleton", :item => "sword",
      :confirmation => "You swing your ⚔  sword ⚔  like Captain Jack Sparrow and crush the skeleton to the ground.",
      :failure => "You attack the skeleton. The ☠  is meaner than you ...if you only had a sword. The skeleton throws you to the ground and gnaws on your bones."
    )

    @kill_spider = Action.new(@player,
      :type => "kill", :thing => "deadly spider", :item => "frog", :remove => "frog",
      :confirmation => "You throw your 🐸  towards the spider. They battle. The frog wins and eats the deadly spider.",
      :failure => "You realize your weapons are useless against the spider. You get bitten. The paralysing poison has an instant effect. Your last thoughts before the spider starts digesting you is of green animals with fast and long tongues..."
    )

    @interact_with_frog = Action.new(@player,
      :type => "interact with", :thing => "frog", :item => "dead fly",
      :confirmation => "You kiss the frog. 🐸  He seems to like it. His tongue is longer.",
      :failure => "You kiss the frog.	🐸  He is disgusted and jumps into the water."
    )

    @rooms[:dark_room].add_action(@push_button)
    @rooms[:bear_room].add_action(@kill_bear)
    @rooms[:skeleton_room].add_action(@kill_skeleton)
    @rooms[:spider_room].add_action(@kill_spider)
    @rooms[:toilet].add_action(@interact_with_frog)
    @rooms[:chest_room].add_action(@open_chest)
    @rooms[:key_room].add_action(@take_key)
  end

  def create_connections
    @rooms[:dark_room].add_exit(:east, @rooms[:spider_room])
    @rooms[:spider_room].add_exit(:west, @rooms[:dark_room])

    @rooms[:dark_room].add_exit(:north, @rooms[:staircase])
    @rooms[:staircase].add_exit(:south, @rooms[:dark_room])

    @rooms[:toilet].add_exit(:south, @rooms[:staircase])
    @rooms[:staircase].add_exit(:north, @rooms[:toilet])

    @rooms[:toilet].add_exit(:west, @rooms[:bear_room])
    @rooms[:bear_room].add_exit(:east, @rooms[:toilet])

    @rooms[:bear_room].add_exit(:south, @rooms[:skeleton_room])
    @rooms[:skeleton_room].add_exit(:north, @rooms[:bear_room])

    @rooms[:key_room].add_exit(:west, @rooms[:staircase])
    @rooms[:staircase].add_exit(:east, @rooms[:key_room])

    @rooms[:chest_room].add_exit(:east, @rooms[:staircase])
    @rooms[:staircase].add_exit(:west, @rooms[:chest_room])
    @rooms[:staircase].lock(:west)
  end
end
