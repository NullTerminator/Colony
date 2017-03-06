require_relative '../../window'
require_relative '../../ui/ui_object'

require_relative '../work_manager'

module Colony

  module Ui

    class WorkTracker < ::Ui::UiObject

      def initialize
        super(0, 0)
        @width = @height = Block::SIZE
        @color = Gosu::Color::GREEN
      end

      def draw
        window = System::Window.instance

        Colony::WorkManager.instance.each_block do |block|
          window.draw_line(block.left, block.top, color, block.right, block.top, color, z)
          window.draw_line(block.right, block.top, color, block.right, block.bottom, color, z)
          window.draw_line(block.right, block.bottom, color, block.left, block.bottom, color, z)
          window.draw_line(block.left, block.bottom, color, block.left, block.top, color, z)
        end
      end

    end

  end

end
