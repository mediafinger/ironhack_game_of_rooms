module Hunger
  def look_for_food
    @food ||= 2  # sets @food to 2 on the first call

    if rand(0..1) == 0
      @food -= 2
      print "There is no food. "
    else
      @food += 1
      print "You find some fast food and eat it. "
    end

    if @food < 0
      puts "You starve to death."
      Game.game_over  # this exits / terminates the program!
    elsif @food > 2
      puts "You get fat."
    else
      puts "You are hungry."
    end
  end
end
