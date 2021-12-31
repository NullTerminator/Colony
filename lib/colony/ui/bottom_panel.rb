module Colony

  module Ui

    class BottomPanel < Wankel::Ui::Container
      def initialize(x, y, width, height)
        super

        @color = Gosu::Color::GRAY
      end
    end

  end

end
