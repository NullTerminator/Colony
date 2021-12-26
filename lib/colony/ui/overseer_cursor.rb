require_relative '../objects/block'

module Colony
  module Ui
    class OverseerCursor < Wankel::Ui::UiObject

      def initialize(input, media)
        size = Block::SIZE * 1.35
        super(size, size)
        @input = input
        @color = Gosu::Color::WHITE

        @texture = media.image(:cursor_arrow)
      end

      def x
        @input.mouse_x
      end

      def y
        @input.mouse_y
      end

      def x_offset
        width * 0.5
      end

      def y_offset
        height * 0.5
      end

      def draw(renderer_fac)
        renderer = renderer_fac.build(self.class)
        renderer.draw(self, x_offset: x_offset, y_offset: y_offset)
      end

    end
  end
end
