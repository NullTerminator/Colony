require_relative "zorder"
require_relative "../ui/ui_object"

module Minesweeper
  class SweepBlock < Ui::UiObject

    attr_accessor :bomb, :flagged, :num_bomb_neighbors
    attr_reader :row, :col, :revealed

    alias :revealed? :revealed
    alias :flagged? :flagged

    def initialize(x, y, row, col)
      super x, y
      @row = row
      @col = col
      @font = System::MediaManager.instance.font(:default_large)
      @num_bomb_neighbors = 0
      @revealed = false
    end

    def bomb?
      return !!@bomb
    end

    def draw
      super
      gap = 1
      System::Window.instance.draw_quad(left + gap, top + gap, color,
                                right - gap, top + gap, color,
                                right - gap, bottom - gap, color,
                                left + gap, bottom - gap, color,
                                z)
      if revealed? && num_bomb_neighbors > 0
        @font.draw(num_bomb_neighbors, x - 10, y - 15, z, 1.0, 1.0, Gosu::Color::BLUE)
      end
    end

    def reveal
      @revealed = true
    end

    def color
      if bomb
        Gosu::Color::GREEN
      else
        hover? ? (@mouse_down ? mouse_down_color : mouse_over_color) : default_color
      end
    end

    def left_clicked
      unless revealed
        if bomb?
          Game.instance.events.trigger(:bomb_hit)
        else
          Game.instance.events.trigger(:block_clicked, self)
        end
      end
    end

    private

    def default_color
      revealed? ? Gosu::Color::WHITE : Gosu::Color::GRAY
    end

    def mouse_over_color
      Gosu::Color::YELLOW
    end

    def mouse_down_color
      Gosu::Color::RED
    end

  end
end
