require 'gosu'

require_relative '../../objects/zorder'
require_relative '../../objects/render_object'

module Colony
  class Block < RenderObject
    SIZE = 50

    def initialize(x, y)
      super(x, y, ZOrder::LEVEL)
      @color = Gosu::Color.argb(0xFF_8B_45_13)
      @width = @height = SIZE
    end

    def draw
      System::Window.instance.draw_quad(left, top, color,
                                right, top, color,
                                right, bottom, color,
                                left, bottom, color,
                                z)
      super
    end
  end
end
