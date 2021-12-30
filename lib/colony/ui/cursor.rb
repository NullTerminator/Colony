module Colony
  module Ui
    class Cursor < Wankel::Ui::UiObject

      def initialize(input, ui, media)
        size = Block::SIZE * 1.35
        super(size, size)
        @input = input
        @ui = ui
        @color = Gosu::Color::WHITE

        @shovel = media.image(:cursor_shovel)
        @arrow = media.image(:cursor_arrow)
      end

      def x
        @input.mouse_x
      end

      def y
        @input.mouse_y
      end

      def texture
        @ui.hit?(x, y) ? @arrow : @shovel
      end

      def x_offset
        width * 0.5
      end

      def y_offset
        texture == @shovel ? -height * 0.5 : height * 0.5
      end

      def draw(renderer_fac)
        renderer = renderer_fac.build(self.class)
        renderer.draw(self, x_offset: x_offset, y_offset: y_offset)
      end

    end
  end
end
