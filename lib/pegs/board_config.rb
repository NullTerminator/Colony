require_relative "../objects/render_object"

module Game
  class BoardConfig < RenderObject

    STEP = 2

    def initialize
      @rows = 11
      @cols = 11

      @x = Window.instance.width * 0.5 - 50
      @y = Window.instance.height * 0.5 - 50
      @z = ZOrder::UI
      @font = MediaManager.instance.font(:default_large)

      input = Input.instance
      input.register(:kb_up, self)
      input.register(:kb_down, self)
      input.register(:kb_left, self)
      input.register(:kb_right, self)
      input.register(:kb_return, self)
    end

    def draw
      @font.draw("ROWS: #{@rows}", @x, @y, @z, 1.0, 1.0, Gosu::Color::BLUE)
      @font.draw("COLS: #{@cols}", @x, @y + 40, @z, 1.0, 1.0, Gosu::Color::BLUE)
    end

    def on_kb_up(down)
      @rows += STEP if down
    end

    def on_kb_down(down)
      @rows -= STEP if down
    end

    def on_kb_right(down)
      @cols += STEP if down
    end

    def on_kb_left(down)
      @cols -= STEP if down
    end

    def on_kb_return(down)
      if down
        Input.instance.unregister(:kb_return, self)
        Game.instance.objects >> self
        Game.instance.events.trigger(:board_configured, @rows, @cols)
      end
    end

  end
end
