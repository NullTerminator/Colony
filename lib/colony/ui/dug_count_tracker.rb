require 'gosu'

require_relative '../../ui/ui_object'

module Colony

  module Ui

    class DugCountTracker < ::Ui::UiObject

      attr_reader :text

      def initialize(eventer)
        super()
        @width = @height = 1
        @color = Gosu::Color::WHITE
        @x = 10
        @y = 50

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
