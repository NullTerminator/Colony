require_relative "../objects/render_object"

module Game
  class ObjectBoard < RenderObject

    def initialize(rows, cols)
      @rows = rows
      @cols = cols

      @y_start = 20.0
      @peg_height = (Window.instance.height - @y_start) / Float(@rows)
      @peg_width = @peg_height
      @x_start = (Window.instance.width * 0.5) - ((Float(@rows) * 0.5) * @peg_width)
      @width = @peg_width * cols
      @height = @peg_height * rows

      super(@x_start + @width * 0.5 - @peg_width * 0.5, @y_start + @height * 0.5 - 10.0, ZOrder::PLAYER)

      reset
    end

    def reset
    end

    def draw
    end

  end
end
