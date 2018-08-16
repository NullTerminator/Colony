require_relative 'objects/block'

require_relative 'path_finder'

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
        return @blocks[get_row(y)][get_column(x)]
      end
    end

    def is_reachable?(block)
      neighbors(block).any?(&:walkable?)
    end

    def neighbors(block)
      row = get_row(block.y)
      col = get_column(block.x)
      n = []
      n << @blocks[row - 1][col] if row > 0
      n << @blocks[row + 1][col] if row < (ROWS - 1)
      n << @blocks[row][col - 1] if col > 0
      n << @blocks[row][col + 1] if col < (COLS - 1)
      n
    end

    def hit?(posx, posy)
      posx >= left && posx <= right && posy >= top && posy <= bottom
    end

    def get_column(x)
      ((x - left) / Block::SIZE).to_i
    end

    def get_row(y)
      ((y - top) / Block::SIZE).to_i
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
          block_left = left + (col_i * Block::SIZE)
          block_top = top + (row_i * Block::SIZE)

          block = @block_factory.build
          block.left = block_left
          block.top = block_top

          if col_i == 40
            block.excavate
          elsif row_i == 0
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
