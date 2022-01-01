module Colony
  module Ui
    class Cursor < Wankel::RenderObject

      def initialize(input, ui, media, mouse_input)
        size = 35.0
        super(size, size, Wankel::ZOrder::CURSOR)
        @color = Gosu::Color::WHITE

        @input = input
        @ui = ui
        @mouse_input = mouse_input

        @dig = media.image(:cursor_dig)
        @arrow = media.image(:cursor_arrow)
        @select = media.image(:cursor_select)
      end

      def x
        @input.mouse_x
      end

      def y
        @input.mouse_y
      end

      def texture
        if @ui.hit?(x, y)
          @arrow
        else
          case @mouse_input.mode
          when MouseInput::SELECT
            @select
          when MouseInput::DIG
            @dig
          end
        end
      end

      def x_offset
        texture == @select ? 0.0 : width * 0.5
      end

      def y_offset
        case texture
        when @dig
          -height * 0.5
        when @select
          height * 0.18
        else
          height * 0.5
        end
      end

      def draw(renderer_fac)
        renderer = renderer_fac.build(self.class)
        renderer.draw(self, x_offset: x_offset, y_offset: y_offset)
      end

    end
  end
end
