require_relative "peg"
require_relative "../ui/container"

module Game
  class Board < Ui::Container

    def initialize(rows, cols)
      @rows = rows
      @cols = cols

      @y_start = 20.0
      @peg_radius = (Window.instance.height - @y_start) / Float(@rows)
      @x_start = (Window.instance.width * 0.5) - ((Float(@rows) * 0.5) * @peg_radius)
      @width = @peg_radius * cols
      @height = @peg_radius * rows

      super(@x_start + @width * 0.5 - @peg_radius * 0.5, @y_start + @height * 0.5 - 10.0)

      reset

      Game.instance.events.register(:peg_clicked, self)
      Input.instance.register(:kb_r, self)
    end

    def reset
      @grid = []
      row_middle = (@rows * 0.5).round - 1
      col_middle = (@cols * 0.5).round - 1

      @rows.times do |row|
        cols = []

        @cols.times do |col|
          x = @x_start + (col * @peg_radius)
          y = (@y_start * 0.5) + (row * @peg_radius) + (@peg_radius * 0.5)

          peg = Peg.new(x, y, row, col)
          peg.radius = @peg_radius - 15
          peg.jumped = row == row_middle && col == col_middle
          add peg

          cols << peg
        end

        @grid << cols
      end
    end

    def on_peg_clicked(peg)
    end

    def on_kb_r(down)
      reset if down
    end

    private

  end
end
