require 'singleton'

require_relative 'main'
require_relative '../window'

require_relative 'objects/block'

module Colony

  class Level

    include Singleton

    ROWS = (1000 / Block::SIZE).to_i
    COLS = (1500 / Block::SIZE).to_i
    WIDTH = Float(COLS * Block::SIZE)
    HEIGHT = Float(ROWS * Block::SIZE)

    attr_reader :left, :right, :top, :bottom,
      :width, :height

    def initialize
      @width = COLS * Block::SIZE
      @height = ROWS * Block::SIZE
      init_blocks
    end

    def get_block_at(x, y)
      if hit?(x, y)
        col = ((x - left) / Block::SIZE).to_i
        row = ((y - top) / Block::SIZE).to_i
        return @blocks[row][col]
      end
    end

    def hit?(posx, posy)
      posx > left && posx < right && posy > top && posy < bottom
    end

    private

    def init_blocks
      @blocks = []

      @left = (System::Window.instance.width * 0.5) - (WIDTH * 0.5)
      @right = left + width
      @top = 10.0
      @bottom = top + height

      ROWS.times do |row_i|
        row = []

        COLS.times do |col_i|
          x = left + (col_i * Block::SIZE) + (Block::SIZE * 0.5)
          y = top + (row_i * Block::SIZE) + (Block::SIZE * 0.5)

          block = Block.new(x, y)
          if row_i == 0
            block.surfacify
          end
          Game.instance.objects << block
          row << block
        end

        @blocks << row
      end
    end
  end
end
