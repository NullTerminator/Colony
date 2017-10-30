require_relative 'objects/block'

module Colony

  class Level

    ROWS = (1000 / Block::SIZE).to_i
    COLS = (1500 / Block::SIZE).to_i
    WIDTH = (COLS * Block::SIZE).to_f
    HEIGHT = (ROWS * Block::SIZE).to_f

    attr_reader :left, :right,
      :top, :bottom,
      :width, :height

    def initialize(block_factory, block_repo, window)
      @width = WIDTH
      @height = HEIGHT
      @block_factory = block_factory
      @block_repo = block_repo
      @window = window

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

      @left = (@window.width * 0.5) - (WIDTH * 0.5)
      @right = left + WIDTH
      @top = 10.0
      @bottom = top + HEIGHT

      ROWS.times do |row_i|
        row = []

        COLS.times do |col_i|
          x = left + (col_i * Block::SIZE) + (Block::SIZE * 0.5)
          y = top + (row_i * Block::SIZE) + (Block::SIZE * 0.5)

          block = @block_factory.build
          block.move_to(x, y)
          if row_i == 0
            block.grassify
          end
          @block_repo << block
          row << block
        end

        @blocks << row
      end
    end
  end
end
