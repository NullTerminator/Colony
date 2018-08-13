require_relative '../../ui/ui_object'

module Colony

  module Ui

    class WorkCountTracker < ::Ui::UiObject

      attr_reader :text

      def initialize(work_manager)
        super()
        @width = @height = 1
        @work_manager = work_manager
        @color = 0xff_ffffff
        @x = 10
        @y = 10
      end

      def update(delta)
        super

        @text = "WORK QUEUE: #{@work_manager.size}"
      end

    end

  end

end
