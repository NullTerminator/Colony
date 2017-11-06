require_relative '../../ui/ui_object'

module Colony

  module Ui

    class WorkTracker < ::Ui::UiObject

      COLOR_REACHABLE = Gosu::Color::GREEN
      COLOR_BLOCKED = Gosu::Color::RED

      def initialize(work_manager, level)
        super()
        @width = @height = Block::SIZE
        @work_manager = work_manager
        @level = level
      end

      def draw(renderer)
        @work_manager.each_block do |block|
          color = @level.is_reachable?(block) ? COLOR_REACHABLE : COLOR_BLOCKED
          renderer.draw(block, color: color, z: z)
        end
      end

    end

  end

end
