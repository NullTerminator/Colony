require_relative "../ui/ui_object"

module Game
  class Peg < Ui::UiObject

    attr_accessor :jumped
    alias :jumped? :jumped

    attr_reader :row, :col

    def initialize(x, y, row, col)
      super x, y
      @row = row
      @col = col
      Game.instance.events.register(:peg_hover_over, self)
      Game.instance.events.register(:peg_hover_out, self)
    end

    def radius=(radius)
      @width = radius
      @height = radius
      @texture = MediaManager.instance.circle width * 0.5
    end

    def jump
      self.jumped = true
    end

    def draw?
      super && (!jumped? || @possible)
    end

    def on_mouse_over
      super
      unless jumped?
        Game.instance.events.trigger(:peg_hover_over, row, col)
      end
    end

    def on_mouse_out
      super
      Game.instance.events.trigger(:peg_hover_out)
    end

    def on_peg_hover_over(row, col)
      if jumped?
        if (row == @row && off_by_2?(col, @col)) || (col == @col && off_by_2?(row, @row))
          @possible = true
        end
      end
    end

    def on_peg_hover_out
      @possible = false
    end

    private

    def off_by_2?(val1, val2)
      (val1 - 2) == val2 || (val1 + 2) == val2
    end

    def color
      if mouse_down?
        mouse_down_color
      elsif hover?
        mouse_over_color
      elsif @possible
        possible_color
      else
        default_color
      end
    end

    def possible_color
      Gosu::Color::GREEN
    end

    def default_color
      Gosu::Color::GRAY
    end

    def mouse_over_color
      Gosu::Color::YELLOW
    end

    def mouse_down_color
      Gosu::Color::RED
    end

  end
end
