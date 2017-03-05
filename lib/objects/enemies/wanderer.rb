module Game
  class Wanderer < Enemy
    def initialize
      super
      @speed = 3.5
      @texture = MediaManager.instance.image(:wanderer)
    end

    def update(delta)
      super

      @vel_x = Gosu::offset_x(angle, 1) * speed
      @vel_y = Gosu::offset_y(angle, 1) * speed
    end
  end
end
