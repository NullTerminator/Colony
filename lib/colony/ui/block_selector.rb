require_relative '../../ui/ui_object'
require_relative '../../system/input'
require_relative '../../window'

require_relative '../level'
require_relative '../objects/block'

module Colony

  module Ui

    class BlockSelector < ::Ui::UiObject

      def initialize
        super(0, 0)
        @width = Block::SIZE
        @height = Block::SIZE
        System::Input.instance.register(:mouse_move, self)
      end

      def on_mouse_move(mx, my, dx, dy)
        if @block = Level.instance.get_block_at(mx, my)
          self.move_to(@block.x, @block.y)
        end
      end

      def draw
        if @block
          window = System::Window.instance
          window.rotate(angle, x, y) do
            window.draw_line(left, top, color, right, top, color, ZOrder::DEBUG)
            window.draw_line(right, top, color, right, bottom, color, ZOrder::DEBUG)
            window.draw_line(right, bottom, color, left, bottom, color, ZOrder::DEBUG)
            window.draw_line(left, bottom, color, left, top, color, ZOrder::DEBUG)
          end
        end
      end

      def color
        Gosu::Color::WHITE
      end

    end

  end

end
