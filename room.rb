class Room
  attr_reader :description
  attr_accessor :north, :west, :south, :east

  def initialize(description)
    @description = description
  end
end
