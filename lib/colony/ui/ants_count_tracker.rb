module Colony

  module Ui

    class AntsCountTracker < Wankel::Ui::UiObject

      attr_reader :text

      def initialize(eventer, media)
        super(30, 30)
        @color = Gosu::Color::WHITE
        @x = 30
        @y = 10
        @texture = media.image(:ant)

        @ants_count = 0

        eventer.register(Events::Ants::SPAWNED, self)
        eventer.register(Events::Ants::KILLED, self)
        set_text
      end

      def on_ant_spawned(ant)
        @ants_count += 1
        set_text
      end

      def on_ant_killed(ant)
        @ants_count -= 1
        set_text
      end

      private

      def set_text
        @text = ": #{@ants_count}"
      end

    end

  end

end
