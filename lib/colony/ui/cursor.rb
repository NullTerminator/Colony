module Colony
  module Ui
    class Cursor < Wankel::RenderObject

      def initialize(input, ui, media)
        size = 35.0
        super(size, size, Wankel::ZOrder::CURSOR)
        @color = Gosu::Color::WHITE

        @input = input
        @ui = ui

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
