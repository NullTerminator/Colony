require_relative "sweep_block"
require_relative "../ui/container"

module Minesweeper
  class SweepGrid < Ui::Container

    def initialize(rows, cols, bombs)
      @rows = rows
      @cols = cols
      @bombs = bombs
      @blocks = []

      y_start = 20.0
      block_height = (System::Window.instance.height - y_start) / Float(@rows)
      block_width = block_height
      x_start = (System::Window.instance.width * 0.5) - ((Float(@rows) * 0.5) * block_width)

      @width = block_width * cols
      @height = block_height * rows

      super(x_start + @width * 0.5 - block_width * 0.5, y_start + @height * 0.5 - 10.0)

      @rows.times do |row|
        cols = []

        @cols.times do |col|
          x = x_start + (col * block_width)
          y = (y_start * 0.5) + (row * block_height) + (block_height * 0.5)

          block = SweepBlock.new(x, y, row, col)
          block.width = block_width
          block.height = block_height
          add block

          cols << block
        end

        @blocks << cols
      end

      @bombs.times do
        row = 0
        col = 0
        loop do
          row = rand(@rows)
          col = rand(@cols)
          break if !@blocks[row][col].bomb
        end
        @blocks[row][col].bomb = true
        each_neighor(row, col) do |block|
          block.num_bomb_neighbors += 1
        end
      end

      Game.instance.events.register(:block_clicked, self)
    end

    def on_block_clicked(block)
      unless block.revealed?
        block.reveal

        if block.num_bomb_neighbors == 0
          each_neighor(block.row, block.col) do |neighbor|
            on_block_clicked neighbor
          end
        end
      end
    end

    private

    def each_neighor(src_row, src_col)
      (-1..1).each do |row_off|
        (-1..1).each do |col_off|
          next if row_off == 0 && col_off == 0

          row = src_row + row_off
          col = src_col + col_off
          next if row < 0 || row >= @rows || col < 0 || col >= @cols

          yield @blocks[row][col]
        end
      end
    end

  end
end
