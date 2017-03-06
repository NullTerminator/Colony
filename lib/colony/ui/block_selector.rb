require_relative '../main'
require_relative '../../ui/ui_object'
require_relative '../../window'

require_relative '../level'
require_relative '../objects/block'

module Colony

  module Ui

    class BlockSelector < ::Ui::UiObject

      def initialize
        super(0, 0)
        @width = @height = Block::SIZE
        @color = Gosu::Color::WHITE
      end

      def left_clicked
        if @block
          Game.instance.events.trigger(:block_clicked, @block)
        end
      end

      def on_mouse_move(mx, my, dx, dy)
        super

        if @block = Level.instance.get_block_at(mx, my)
          move_to(@block.x, @block.y)
        end
      end

      def draw
        if @block && @block.is_workable?
          window = System::Window.instance
          window.draw_line(left, top, color, right, top, color, z)
          window.draw_line(right, top, color, right, bottom, color, z)
          window.draw_line(right, bottom, color, left, bottom, color, z)
          window.draw_line(left, bottom, color, left, top, color, z)
        end
      end

    end

  end

end
