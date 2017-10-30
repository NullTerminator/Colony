require "gosu"
require_relative 'zorder'

class RenderObject

  class << self
    attr_accessor :renderer
  end

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
    @x = 0
    @y = 0
    @angle = 0.0
    show
    self
  end

  def update(delta)
    texture.update(delta) if texture && texture.respond_to?(:update)
  end

  def draw
    if self.class.renderer
      self.class.renderer.draw(self)
    else
      raise "No renderer set for #{self.class}"
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

  private

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
