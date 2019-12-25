require "gosu"
require_relative 'zorder'

class RenderObject

  attr_accessor :texture, :x, :y, :z, :width, :height,
                :angle, :scale_x, :scale_y,
                :color, :visible

  alias :visible? :visible

  def initialize(z, tex = nil, scale_x = 1.0, scale_y = 1.0, color = Gosu::Color::FUCHSIA)
    @z = z
    @texture = tex
    @scale_x, @scale_y = scale_x, scale_y
    @color = color
    init
  end

  def init
    @x = 0.0
    @y = 0.0
    @angle = 0.0
    show
    self
  end

  def update(delta)
    texture.update(delta) if texture && texture.respond_to?(:update)
  end

  def draw(renderer_fac)
    renderer = renderer_fac.build(self.class)
    renderer.draw(self)
  end

  def move_to(x, y)
    self.x = x
    self.y = y
  end

  def look_at(obj)
    look_at_pos(obj.x, obj.y)
  end

  def look_at_pos(pos_x, pos_y)
    self.angle = Gosu.angle(x, y, pos_x, pos_y)
  end

  def color_gl
    color ? color.gl : 0xffffffff
  end

  def left
    x - width * 0.5
  end

  def left=(new_left)
    self.x = new_left + (width * 0.5)
  end

  def right
    x + width * 0.5
  end

  def right=(new_right)
    self.x = new_right - (width * 0.5)
  end

  def top
    y - height * 0.5
  end

  def top=(new_top)
    self.y = new_top + (height * 0.5)
  end

  def bottom
    y + height * 0.5
  end

  def bottom=(new_bottom)
    self.y = new_bottom - (height * 0.5)
  end

  def width
    @width * scale_x
  end

  def height
    @height * scale_y
  end

  def front_x
    x + Gosu.offset_x(angle, height * 0.5)
  end

  def front_y
    y + Gosu.offset_y(angle, height * 0.5)
  end

  def collide?(other)
    other.left < right && other.right > left && other.top < bottom && other.bottom > top
  end

  def hit?(posx, posy)
    posx > left && posx < right && posy > top && posy < bottom
  end

  def close_enough_to?(posx, posy)
    (x - posx).abs <= 1.0 && (y - posy).abs <= 1.0
  end

  def hide
    self.visible = false
  end

  def show
    self.visible = true
  end

  def toggle_visible
    self.visible = !visible
  end

end
