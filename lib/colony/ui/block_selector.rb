require_relative '../../ui/ui_object'

require_relative '../objects/block'
require_relative '../events'

module Colony

  module Ui

    class BlockSelector < ::Ui::UiObject

      def initialize(level, eventer)
        super()
        @width = @height = Block::SIZE
        @color = Gosu::Color::WHITE
        @level = level
        @eventer = eventer
      end

      def left_clicked
        if @block
          @eventer.trigger(Events::Ui::BLOCK_CLICKED, @block)
        end
      end

      def on_mouse_move(mx, my, dx, dy)
        super

        if @block = @level.get_block_at(mx, my)
          move_to(@block.x, @block.y)
        end
      end

      def draw
        if @block && @block.is_workable?
          self.class.renderer.draw(@block, color: color, z: z)
        end
      end

    end

  end

end
