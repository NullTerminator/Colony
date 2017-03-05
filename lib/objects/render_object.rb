require "gosu"
require_relative 'zorder'

class RenderObject

  attr_accessor :texture, :x, :y, :z, :width, :height,
                :angle, :scale_x, :scale_y,
                :color, :visible
  alias :visible? :visible

  def initialize(x, y, z, tex = nil, scale_x = 1.0, scale_y = 1.0, color = Gosu::Color::WHITE)
    @x, @y, @z = x, y, z
    @texture = tex
    @scale_x, @scale_y = scale_x, scale_y
    @color = color
    @angle = 0.0
    @visible = true
  end

  def update(delta)
    texture.update(delta) if texture && texture.respond_to?(:update)
  end

  def draw
    if Game.instance.debug
      dbc = Gosu::Color::WHITE
      window = System::Window.instance
      window.rotate(angle, x, y) do
        window.draw_line(left, top, dbc, right, top, dbc, ZOrder::DEBUG)
        window.draw_line(right, top, dbc, right, bottom, dbc, ZOrder::DEBUG)
        window.draw_line(right, bottom, dbc, left, bottom, dbc, ZOrder::DEBUG)
        window.draw_line(left, bottom, dbc, left, top, dbc, ZOrder::DEBUG)
      end
    end
    if draw?
      texture.draw_rot(x, y, z, angle, 0.5, 0.5, scale_x, scale_y, color)#_gl)
    end
  end

  def move_to(x, y)
    self.x = x
    self.y = y
  end

  def look_at(obj)
    self.angle = Gosu::angle(@x, @y, obj.x, obj.y)
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
    Float(@width || texture.width) * scale_x
  end

  def height
    Float(@height || texture.height) * scale_y
  end

  def collide?(other)
    other.left < right && other.right > left && other.top < bottom && other.bottom > top
  end

  def hit?(posx, posy)
    posx > left && posx < right && posy > top && posy < bottom
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

  def kill
    Game.instance.objects >> self
  end

  private

  def draw?
    texture && visible
  end

  def keep_on_screen
    window = System::Window.instance
    if top < 0
      self.top = 0
    end

    if left < 0
      self.left = 0
    end

    if bottom > window.height
      self.bottom = window.height
    end

    if right > window.width
      self.right = window.width
    end
  end

end
