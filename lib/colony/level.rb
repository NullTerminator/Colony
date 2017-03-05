require 'singleton'

require_relative 'main'
require_relative '../window'

require_relative 'objects/block'

module Colony

  class Level

    include Singleton

    ROWS = 20
    COLS = 30
    WIDTH = Float(COLS * Block::SIZE)
    HEIGHT = Float(ROWS * Block::SIZE)

    def initialize
      init_blocks
    end

    def get_block_at(x, y)
      if hit?(x, y)
        col = ((x - left) / Block::SIZE).to_i
        row = ((y - top) / Block::SIZE).to_i
        return @blocks[row][col]
      end
    end

    def left
      @blocks[0][0].left
    end

    def right
      @blocks[-1][-1].right
    end

    def top
      @blocks[0][0].top
    end

    def bottom
      @blocks[-1][-1].bottom
    end

    def hit?(posx, posy)
      posx > left && posx < right && posy > top && posy < bottom
    end

    private

    def init_blocks
      @blocks = []

      @x_start = (System::Window.instance.width * 0.5) - (WIDTH * 0.5)
      @y_start = 20.0

      ROWS.times do |row_i|
        row = []

        COLS.times do |col_i|
          x = @x_start + (col_i * Block::SIZE)
          y = (@y_start * 0.5) + (row_i * Block::SIZE) + (Block::SIZE * 0.5)

          block = Block.new(x, y)
          Game.instance.objects << block
          row << block
        end

        @blocks << row
      end
    end
  end
end
