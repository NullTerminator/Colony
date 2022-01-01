module Colony

  module Ui

    class WorkCountTracker < Wankel::Ui::UiObject

      attr_reader :text

      def initialize(work_manager)
        super(1, 1)
        @color = Gosu::Color::WHITE
        @x = 10
        @y = 30

        @work_manager = work_manager
        set_text
      end

      def update(delta)
        super

        set_text
      end

      private

      def set_text
        if @work_count != @work_manager.count
          @work_count = @work_manager.count
          @text = "WORK QUEUE: #{@work_manager.count}"
        end
      end

    end

  end

end
