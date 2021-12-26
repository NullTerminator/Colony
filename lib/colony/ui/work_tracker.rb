module Colony

  module Ui

    class WorkTracker < Wankel::Ui::UiObject

      COLOR_REACHABLE = Gosu::Color.new(64, 0, 255, 0)
      COLOR_BLOCKED = Gosu::Color.new(64, 255, 0, 0)

      def initialize(work_manager, level)
        super(Block::SIZE, Block::SIZE)
        @work_manager = work_manager
        @level = level
      end

      def draw(renderer_fac)
        renderer = renderer_fac.build(self.class)

        @work_manager.each_job do |job|
          color = @level.is_reachable?(job.block) ? COLOR_REACHABLE : COLOR_BLOCKED
          renderer.draw(job.block, color: color, z: z)
        end
      end

    end

  end

end
