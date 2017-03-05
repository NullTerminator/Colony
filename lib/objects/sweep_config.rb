require_relative "render_object"
require_relative "zorder"
require_relative "sweep_grid"
require_relative "../system/media_manager"

module Minesweeper
  class SweepConfig < RenderObject

    def initialize
      @rows = 20
      @cols = 20
      @bombs = 80

      @x = System::Window.instance.width * 0.5 - 50
      @y = System::Window.instance.height * 0.5 - 50
      @z = ZOrder::UI
      @font = System::MediaManager.instance.font(:default_large)

      input = System::Input.instance
      input.register(:kb_up, self)
      input.register(:kb_down, self)
      input.register(:kb_left, self)
      input.register(:kb_right, self)
      input.register(:kb_return, self)
      input.register(:kb_b, self)
      input.register(:kb_n, self)
    end

    def draw
      @font.draw("ROWS: #{@rows}", @x, @y, @z, 1.0, 1.0, Gosu::Color::BLUE)
      @font.draw("COLS: #{@cols}", @x, @y + 40, @z, 1.0, 1.0, Gosu::Color::BLUE)
      @font.draw("BOMBS: #{@bombs}", @x, @y + 80, @z, 1.0, 1.0, Gosu::Color::BLUE)
    end

    def on_kb_up(down)
      @rows -= 1 if down
    end

    def on_kb_down(down)
      @rows += 1 if down
    end

    def on_kb_right(down)
      @cols += 1 if down
    end

    def on_kb_left(down)
      @cols -= 1 if down
    end

    def on_kb_b(down)
      @bombs += 1 if down
    end

    def on_kb_n(down)
      @bombs -= 1 if down
    end

    def on_kb_return(down)
      if down
        System::Input.instance.unregister(:kb_return, self)
        objects = Game.instance.objects
        objects >> self
        Game.instance.events.trigger(:sweep_configured, @rows, @cols, @bombs)
      end
    end

  end
end
