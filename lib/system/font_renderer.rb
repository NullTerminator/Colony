require_relative 'renderer'

module System
  class FontRenderer < Renderer

    def initialize(font)
      @font = font
    end

    def draw(obj, opts={})
      if obj.visible?
        @font.draw_text(obj.text, obj.x, obj.y, ZOrder::UI, 1.0, 1.0, obj.color)
      end
    end

    def draw_text(text, x, y, color)
      @font.draw_text(text, x, y, ZOrder::UI, 1.0, 1.0, color)
    end

  end
end
