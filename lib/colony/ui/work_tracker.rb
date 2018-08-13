require_relative '../../ui/ui_object'

module Colony

  module Ui

    class WorkTracker < ::Ui::UiObject

      COLOR_REACHABLE = 0x2f_00ff00 #GREEN
      COLOR_BLOCKED = 0x2f_ff0000 #RED

      def initialize(work_manager, level)
        super()
        @width = @height = Block::SIZE
        @work_manager = work_manager
        @level = level
      end

      def draw(renderer_fac)
        renderer = renderer_fac.build(self.class)

        @work_manager.each_block do |block|
          color = @level.is_reachable?(block) ? COLOR_REACHABLE : COLOR_BLOCKED
          renderer.draw(block, color: color, z: z)
        end
      end

    end

  end

end
