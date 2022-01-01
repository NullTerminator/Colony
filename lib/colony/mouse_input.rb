module Colony
  class MouseInput

    SELECT = :select
    DIG = :dig

    attr_reader :mode

    def initialize(eventer, level, ant_repo, input)
      @eventer = eventer
      @level = level
      @ant_repo = ant_repo

      @mode = SELECT

      input.register(:kb_1, self)
      input.register(:kb_2, self)

      @eventer.register(Events::Camera::MOUSE_MOVE, self)
      @eventer.register(Events::Camera::MOUSE_LEFT, self)
      @eventer.register(Events::Camera::MOUSE_RIGHT, self)
    end

    def on_kb_1(down)
      if down
        @mode = SELECT
        @eventer.trigger(Events::Dig::CLEAR)
      end
    end

    def on_kb_2(down)
      if down
        @mode = DIG
      end
    end

    def on_camera_mouse_left(down, x, y)
      case @mode
      when SELECT
        return unless down
        if ant = @ant_repo.all.find { |ant| ant.hit?(x, y) }
          @eventer.trigger(Events::Ants::SELECTED, ant)
        else
          @eventer.trigger(Events::Selection::CLEAR)
        end
      when DIG
        if block = @level.get_block_at(x, y)
          @eventer.trigger(Events::Blocks::CLICKED, block, down)
        end
      end
    end

    def on_camera_mouse_right(down, cx, cy)
      case @mode
      when SELECT
        @eventer.trigger(Events::Selection::CLEAR) if down
      when DIG
        @eventer.trigger(Events::Dig::CLEAR, cx, cy) if down
      end
    end

    def on_camera_mouse_move(cx, cy, dx, dy)
      case @mode
      when DIG
        @eventer.trigger(Events::Dig::MOUSE_MOVE, cx, cy, dx, dy)
      end
    end
  end
end
