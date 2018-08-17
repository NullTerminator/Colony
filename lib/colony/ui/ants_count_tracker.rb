require 'gosu'

require_relative '../../ui/ui_object'

module Colony

  module Ui

    class AntsCountTracker < ::Ui::UiObject

      attr_reader :text

      def initialize(eventer)
        super()
        @width = @height = 1
        @color = Gosu::Color::WHITE
        @x = 10
        @y = 10

        @ants_count = 0

        eventer.register(Events::Ants::SPAWNED, self)
        eventer.register(Events::Ants::KILLED, self)
      end

      def update(delta)
        super

        @text = "ANTS: #{@ants_count}"
      end

      def on_ant_spawned(ant)
        @ants_count += 1
      end

      def on_ant_killed(ant)
        @ants_count -= 1
      end

    end

  end

end