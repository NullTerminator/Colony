module Game
  class Seeker < Enemy
    def initialize
      super
      @speed = 5.0
      @texture = MediaManager.instance.image(:seeker)
      @score_value = 5
    end

    def update(delta)
      player = Player.instance
      @angle = Gosu::angle(x, y, player.x, player.y)

      @vel_x = Gosu::offset_x(angle, 1) * speed
      @vel_y = Gosu::offset_y(angle, 1) * speed

      super
    end
  end
end
