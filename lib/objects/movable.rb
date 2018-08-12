require_relative "render_object"

class Movable < RenderObject

  attr_accessor :vel_x, :vel_y, :speed

  def initialize(z)
    super(z)
    @speed = 0
    @vel_x = 0.0
    @vel_y = 0.0
  end

  def move_up
    @angle = 0
    move
  end

  def move_down
    @angle = 180
    move
  end

  def move_left
    @angle = 270
    move
  end

  def move_right
    @angle = 90
    move
  end

  def moving_right?
    vel_x > 0.0
  end

  def moving_left?
    vel_x < 0.0
  end

  def move(spd = speed)
    @vel_x = Gosu::offset_x(angle, spd)
    @vel_y = Gosu::offset_y(angle, spd)
  end

  def stop
    @vel_x = 0.0
    @vel_y = 0.0
  end

  def update(delta)
    @x += vel_x * delta
    @y += vel_y * delta

    super
  end
end
