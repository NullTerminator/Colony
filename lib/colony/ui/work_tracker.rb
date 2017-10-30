require_relative '../../ui/ui_object'

module Colony

  module Ui

    class WorkTracker < ::Ui::UiObject

      def initialize(work_manager)
        super()
        @width = @height = Block::SIZE
        @color = Gosu::Color::GREEN
        @work_manager = work_manager
      end

      def draw
        @work_manager.each_block do |block|
          self.class.renderer.draw(block, color: color, z: z)
        end
      end

    end

  end

end
