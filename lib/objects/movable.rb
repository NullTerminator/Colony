require_relative "render_object"

class Movable < RenderObject

  attr_accessor :vel_x, :vel_y, :speed

  def initialize(z)
    super(z)
    @speed = 0
    @vel_x = 0.0
    @vel_y = 0.0
  end

  def update(delta)
    @x += vel_x
    @y += vel_y

    super
  end
end
