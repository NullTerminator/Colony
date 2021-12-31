require_relative 'objects/block'
require_relative 'objects/chunk'

module Colony

  class Level

    def initialize(block_factory, camera)
      @block_factory = block_factory
      @camera = camera

      @chunks = []

      ensure_chunks_in_cam
    end

    def get_block_at(x, y)
      get_chunk_at(x, y)&.get_block_at(x, y)
    end

    def get_block_at_screen(x, y)
      get_block_at(x + @camera.x, y + @camera.y)
    end

    def is_reachable?(block)
      neighbors(block).any?(&:walkable?)
    end

    def neighbors(block)
      n = []
      n << get_block_at(block.x, block.y - Block::SIZE)
      n << get_block_at(block.x, block.y + Block::SIZE)
      n << get_block_at(block.x - Block::SIZE, block.y)
      n << get_block_at(block.x + Block::SIZE, block.y)
      n.compact
    end

    def get_blocks_in_rect(start_block, end_block)
      start_x = start_block.x
      end_x = end_block.x
      x_step = end_x >= start_x ? Block::SIZE : -Block::SIZE

      start_y = start_block.y
      end_y = end_block.y
      y_step = end_y >= start_y ? Block::SIZE : -Block::SIZE

      blocks = []
      start_x.step(end_x, x_step) do |x|
        start_y.step(end_y, y_step) do |y|
          blocks << get_block_at(x, y)
        end
      end

      blocks
    end

    def update(delta)
      ensure_chunks_in_cam

      #@chunks.each do |row|
        #row.values.each do |chunk|
          #chunk.update(delta)
        #end
      #end
    end

    def draw(renderer_fac)
      chunk_rows_in_cam.each do |row|
        chunk_cols_in_cam.each do |col|
          @chunks[row][col].draw(renderer_fac)
        end
      end
    end

    private

    def get_chunk_at(x, y)
      return nil if y.negative?

      col = x / Chunk::WIDTH
      col -= 1 if col.negative?
      @chunks[(y / Chunk::HEIGHT).to_i][col.to_i]
    end

    def chunk_rows_in_cam
      (@camera.top / Chunk::HEIGHT).to_i..(@camera.bottom / Chunk::HEIGHT).to_i
    end

    def chunk_cols_in_cam
      # Rows start at index 0 and increas as they go down.  Cols start at 0, but are negative going left.
      # when the value is -1.58 is really 2 columns over, so we want -2.  Converting to an int will drop
      # the decimal, which is fine for positives, but negatives we want another over
      left = @camera.left / Chunk::WIDTH
      left -= 1 if left.negative?
      right = @camera.right / Chunk::WIDTH
      right -= 1 if right.negative?
      left.to_i..right.to_i
    end

    def ensure_chunks_in_cam
      chunk_rows_in_cam.each do |row|
        chunk_cols_in_cam.each do |col|
          @chunks[row] ||= {}
          @chunks[row][col] ||= Chunk.new(row, col, @block_factory)
        end
      end
    end
  end
end
