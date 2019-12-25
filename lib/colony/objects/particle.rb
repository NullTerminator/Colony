require_relative '../../objects/zorder'
require_relative '../../objects/movable'

module Colony

  class Particle < Movable

    def initialize(x, y, angle, size, color, speed)
      super(ZOrder::ENVIRONMENT)
      @x = x
      @y = y
      @angle = angle
      @width = size
      @height = size
      @color = color
      @speed = speed
      move
    end

  end

end
