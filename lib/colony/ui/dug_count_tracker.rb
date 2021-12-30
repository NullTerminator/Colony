module Colony

  module Ui

    class DugCountTracker < Wankel::Ui::UiObject

      attr_reader :text

      def initialize(eventer)
        super(1, 1)
        @color = Gosu::Color::WHITE
        @x = 10
        @y = 950

        @dug_count = 0

        eventer.register(Events::Blocks::DUG, self)
      end

      def update(delta)
        super

        @text = "BLOCKS DUG: #{@dug_count}"
      end

      def on_block_dug(block)
        @dug_count += 1
      end

    end

  end

end
