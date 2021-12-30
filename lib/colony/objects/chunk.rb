require_relative 'block'

module Colony

  class Chunk

    SIZE = 40
    WIDTH = SIZE * Block::SIZE
    HEIGHT = SIZE * Block::SIZE

    def initialize(row, col, block_factory)
      @row = row
      @col = col

      @blocks = []

      SIZE.times do |row_i|
        block_row = []

        SIZE.times do |col_i|
          block = if row_i == 0 && row == 0
                    block_factory.grass
                  elsif rand(1..30) == 1
                    block_factory.stone
                  else
                    block_factory.dirt
                  end
          block.left = col * WIDTH + col_i * Block::SIZE
          # Set bottom so grass is correct
          block.bottom = row * HEIGHT + (row_i * Block::SIZE) + Block::SIZE

          block_row << block
        end

        @blocks << block_row
      end
    end

    def top
      @row * HEIGHT
    end

    def bottom
      top + HEIGHT
    end

    def left
      @row * WIDTH
    end

    def right
      left + WIDTH
    end

    def get_block_at(bx, by)
      @blocks[(by % HEIGHT / Block::SIZE).to_i][(bx % WIDTH / Block::SIZE).to_i]
    end

    def update(delta)
      each_block do |block|
        block.update(delta)
      end
    end

    def draw(renderer_fac)
      each_block do |block|
        block.draw(renderer_fac)
      end
    end

    private

    def each_block
      @blocks.each do |block_row|
        block_row.each do |block|
          yield block
        end
      end
    end

  end

end
