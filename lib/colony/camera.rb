module Colony
  class Camera < Wankel::Camera
    def initialize(input, eventer, width:, height:)
      super(width, height)
      @speed = 550.0
      @y_limit = height * -0.8

      @eventer = eventer

      input.register(:kb_w, self)
      input.register(:kb_s, self)
      input.register(:kb_a, self)
      input.register(:kb_d, self)
      input.register(:kb_h, self)

      input.register(:mouse_move, self)
      input.register(:mouse_left, self)
      input.register(:mouse_right, self)
    end

    def update(delta)
      super

      @eventer.trigger(Events::Camera::MOVE, x, y) unless @vel_x.zero? && @vel_y.zero?

      # Enforce boundaries
      if y < @y_limit
        @y = @y_limit
      end

    end

    def on_kb_w(down)
      if down
        @vel_y = Gosu::offset_y(0, speed)
      else
        @vel_y = 0.0
      end
    end

    def on_kb_s(down)
      if down
        @vel_y = Gosu::offset_y(180, speed)
      else
        @vel_y = 0.0
      end
    end

    def on_kb_a(down)
      if down
        @vel_x = Gosu::offset_x(270, speed)
      else
        @vel_x = 0.0
      end
    end

    def on_kb_d(down)
      if down
        @vel_x = Gosu::offset_x(90, speed)
      else
        @vel_x = 0.0
      end
    end

    def on_kb_h(down)
      @x = 0.0
      @y = 0.0
    end

    def on_mouse_move(mx, my, dx, dy)
      game_x = mx + x
      game_y = my + y
      if hit?(game_x, game_y)
        @eventer.trigger(Events::Camera::MOUSE_MOVE, game_x, game_y, dx, dy)
      else
        @eventer.trigger(Events::Camera::MOUSE_OUT)
      end
    end

    def on_mouse_left(down, mx, my)
      game_x = mx + x
      game_y = my + y
      if hit?(game_x, game_y)
        @eventer.trigger(Events::Camera::MOUSE_LEFT, down, game_x, game_y)
      end
    end

    def on_mouse_right(down, mx, my)
      game_x = mx + x
      game_y = my + y
      if hit?(game_x, game_y)
        @eventer.trigger(Events::Camera::MOUSE_RIGHT, down, game_x, game_y)
      end
    end
  end
end
