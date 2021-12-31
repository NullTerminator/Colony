module Colony

  module Ui

    class DugCountTracker < Wankel::Ui::UiObject

      attr_reader :text

      def initialize(eventer)
        super(1, 1)
        @color = Gosu::Color::WHITE
        @x = 10
        @y = 50

        @dug_count = 0

        eventer.register(Events::Blocks::DUG, self)
      end

      def on_block_dug(block)
        @dug_count += 1
        set_text
      end

      private

      def set_text
        @text = "BLOCKS DUG: #{@dug_count}"
      end

    end

  end

end
