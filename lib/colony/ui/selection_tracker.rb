module Colony

  module Ui

    class SelectionTracker < Wankel::Ui::UiObject

      attr_reader :selected, :text

      def initialize(x, y, width, height, media, eventer)
        super(width, height)
        @x = x
        @y = y

        @ant = media.image(:ant)

        @selected = nil

        eventer.register(Events::Ants::SELECTED, self)
        eventer.register(Events::Selection::CLEAR, self)
      end

      def on_ant_selected(ant)
        @selected = ant
        @texture = @ant
        @text = "ANT: #{ant.id}\nDAMAGE: #{ant.damage}\nSPEED: #{ant.speed.to_i}"
      end

      def on_selection_clear
        @selected = nil
        @text = nil
      end

    end

  end

end
