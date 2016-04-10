class Map
  def initialize(player)
    @player = player  # needed to pass into the actions
  end

  def setup
    create_rooms
    create_actions
    create_connections

    @dark_room  # return the first room, in which the player starts
  end

  private

  def create_rooms
    @dark_room = Room.new("You are in a dark room. You can barely see anything.")
    @spider_room = Room.new("You are in a dark room. You can barely see anything. Something is hanging from the ceiling. It feels like silk... but sticky.")
    @key_room = Room.new("You enter a dimly lit room full of stuff. You are sure you can find something useful.")
    @bear_room = Room.new("You open a cage. It smells. Something is lying in the corner.")
    @skeleton_room = Room.new("You open a cage. Some bones are hanging in chains from the ceiling.")
    @toilet = Room.new("Your nose is convinced you found the bathroom. Not the cleanest though.")
    @chest_room = Room.new("After passing through a long hallway you enter a small chamber with massive stone walls.")
    @staircase = Room.new("You found a staircase. There are narrow stairs in various directions.")
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
      :type => "kill", :thing => "deadly spider", :item => "frog",
      :confirmation => "You throw your 🐸  towards the spider. They battle. The frog wins and eats the deadly spider.",
      :failure => "You realize your weapons are useless against the spider. You get bitten. The paralysing poison has an instant effect. Your last thoughts before the spider starts digesting you is of green animals with fast and long tongues..."
    )

    @interact_with_frog = Action.new(@player,
      :type => "interact with", :thing => "frog", :item => "dead fly",
      :confirmation => "You kiss the frog. 🐸  He seems to like it. His tongue is longer.",
      :failure => "You kiss the frog.	🐸  He is disgusted and jumps into the water."
    )

    @dark_room.add_action(@push_button)
    @bear_room.add_action(@kill_bear)
    @skeleton_room.add_action(@kill_skeleton)
    @spider_room.add_action(@kill_spider)
    @toilet.add_action(@interact_with_frog)
    @chest_room.add_action(@open_chest)
    @key_room.add_action(@take_key)
  end

  def create_connections
    @dark_room.add_exit(:east, @spider_room)
    @spider_room.add_exit(:west, @dark_room)

    @dark_room.add_exit(:north, @staircase)
    @staircase.add_exit(:south, @dark_room)

    @toilet.add_exit(:south, @staircase)
    @staircase.add_exit(:north, @toilet)

    @toilet.add_exit(:west, @bear_room)
    @bear_room.add_exit(:east, @toilet)

    @bear_room.add_exit(:south, @skeleton_room)
    @skeleton_room.add_exit(:north, @bear_room)

    @key_room.add_exit(:west, @staircase)
    @staircase.add_exit(:east, @key_room)

    @chest_room.add_exit(:east, @staircase)
    @staircase.add_exit(:west, @chest_room)
    @staircase.lock(:west)
  end
end
