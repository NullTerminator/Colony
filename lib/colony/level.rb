require_relative 'objects/block'

require_relative 'path_finder'

module Colony

  class Level

    def initialize(block_factory, block_repo, window, camera)
      @block_factory = block_factory
      @block_repo = block_repo
      @window = window
      @camera = camera

      init_blocks
    end

    def get_block_at(x, y)
      if row = @blocks[get_row(y)]
        row[get_column(x)]
      end
    end

    def get_block_at_screen(x, y)
      get_block_at(x + @camera.x, y + @camera.y)
    end

    def is_reachable?(block)
      neighbors(block).any?(&:walkable?)
    end

    def neighbors(block)
      row = get_row(block.y)
      col = get_column(block.x)
      n = []
      n << @blocks[row - 1][col]
      n << @blocks[row + 1][col]
      n << @blocks[row][col - 1]
      n << @blocks[row][col + 1]
      n.compact
    end

    def get_blocks_in_rect(start_block, end_block)
      start_col = get_column(start_block.x)
      end_col = get_column(end_block.x)
      col_dir = end_col >= start_col ? 1 : -1

      start_row = get_row(start_block.y)
      end_row = get_row(end_block.y)
      row_dir = end_row >= start_row ? 1 : -1

      blocks = []
      start_col.step(end_col, col_dir) do |col|
        start_row.step(end_row, row_dir) do |row|
          blocks << @blocks[row][col]
        end
      end

      blocks
    end

    def get_column(x)
      (x / Block::SIZE).to_i
    end

    def get_row(y)
      (y / Block::SIZE).to_i
    end

    private

    def init_blocks
      @blocks = []

      45.times do |row_i|
        row = []

        60.times do |col_i|
          block = if col_i == 40 && row_i < 7
                    @block_factory.tunnel
                  elsif row_i == 0
                    @block_factory.grass
                  else
                    @block_factory.dirt
                  end
          block.left = col_i * Block::SIZE
          block.bottom = (row_i * Block::SIZE) + Block::SIZE

          @block_repo << block
          row << block
        end

        @blocks << row
      end
    end
  end
end
