module Colony

  module Ui

    class WorkCountTracker < Wankel::Ui::UiObject

      attr_reader :text

      def initialize(work_manager)
        super(1, 1)
        @work_manager = work_manager
        @color = Gosu::Color::WHITE
        @x = 10
        @y = 930
      end

      def update(delta)
        super

        @text = "WORK QUEUE: #{@work_manager.count}"
      end

    end

  end

end
