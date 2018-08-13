require_relative 'renderer'

module System
  class FontRenderer < Renderer

    def initialize(font)
      @font = font
    end

    def draw(obj, opts={})
      if obj.visible?
        @font.draw(obj.text, obj.x, obj.y, ZOrder::UI, 1.0, 1.0, obj.color)
      end
    end

  end
end
