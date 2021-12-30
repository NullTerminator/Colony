module Colony

  module Ui

    class BottomPanel < Wankel::Ui::Container
      def initialize
        super(1920 * 0.5, 950, 1920, 180)

        @color = Gosu::Color::GRAY
      end
    end

  end

end
