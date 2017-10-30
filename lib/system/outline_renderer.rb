require 'gosu'

require_relative 'renderer'

module System
  class OutlineRenderer < Renderer

    def draw(obj, opts={})
      super

      color = opts[:color] || Gosu::Color::WHITE
      z = opts[:z] || obj.z
      @window.rotate(obj.angle, obj.x, obj.y) do
        @window.draw_line(obj.left, obj.top, color, obj.right, obj.top, color, z)
        @window.draw_line(obj.right, obj.top, color, obj.right, obj.bottom, color, z)
        @window.draw_line(obj.right, obj.bottom, color, obj.left, obj.bottom, color, z)
        @window.draw_line(obj.left, obj.bottom, color, obj.left, obj.top, color, z)
      end
    end

  end
end
