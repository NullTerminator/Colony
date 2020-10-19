require_relative '../../ui/ui_object'

module Colony
  module Ui
    class Cursor < ::Ui::UiObject

      def initialize(input, level, media)
        super()
        @width = @height = Block::SIZE * 1.35
        @input = input
        @level = level
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
        @level.get_block_at(x, y) ? @shovel : @arrow
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
