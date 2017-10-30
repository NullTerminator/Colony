require_relative 'renderer'

module System
  class FillRenderer < Renderer

    def draw(obj, opts={})
      super

      if obj.visible?
        color = opts[:color] || obj.color
        z = opts[:z] || obj.z
        @window.draw_quad(obj.left, obj.top, color,
                          obj.right, obj.top, color,
                          obj.right, obj.bottom, color,
                          obj.left, obj.bottom, color,
                          z)
      end
    end

  end
end
