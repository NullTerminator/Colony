module Game
  class Bullet < Movable
    def initialize
      super
      @z = ZOrder::PROJECTILES
      @texture = MediaManager.instance.image(:bullet)
      @speed = 20.0
      @width = 8.0
      @height = 15.0
    end

    def update(delta)
      super
      Game.instance.enemies.objects.each do |enemy|
        if collide?(enemy)
          kill
          enemy.kill
        end
      end
    end

    def shoot(at_angle)
      @angle = at_angle
      @vel_x = Gosu::offset_x(angle, 1) * speed
      @vel_y = Gosu::offset_y(angle, 1) * speed
    end
  end
end
