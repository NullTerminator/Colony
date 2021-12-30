require_relative '../objects/block'
require_relative '../events'

module Colony

  module Ui

    class BlockSelector < Wankel::Ui::UiObject

      MODE_DIG = :dig
      MODE_FILL = :fill

      def initialize(level, work_manager, job_factory, input, eventer)
        super(Block::SIZE, Block::SIZE)
        @color = Gosu::Color::WHITE

        @mode = MODE_DIG
        @batch_start = nil
        @batch = nil
        @block = nil

        @level = level
        @work_manager = work_manager
        @job_factory = job_factory
        @input = input

        @input.register(:kb_f, self)
        eventer.register(Events::Blocks::CLICKED, self)
        eventer.register(Events::Camera::MOVE, self)
        eventer.register(Events::Camera::MOUSE_MOVE, self)
        eventer.register(Events::Camera::MOUSE_RIGHT, self)
      end

      def on_block_clicked(block, down)
        unless down
          if @batch
            work_on_batch
          elsif @mouse_down
            job = job_for_block(@block)
            @work_manager.toggle(job) if job
          end
        end
        @mouse_down = down
      end

      def on_camera_mouse_move(mx, my, dx, dy)
        find_block(mx, my)
      end

      def on_camera_mouse_right(down, mx, my)
        @batch = nil
        @batch_start = nil
        @block = nil
        @mouse_down = false
        find_block(@input.mouse_x, @input.mouse_y)
      end

      def on_camera_move(cx, cy)
        find_block(@input.mouse_x, @input.mouse_y)
      end

      def draw(renderer_fac)
        if @batch
          renderer = renderer_fac.build(self.class)
          @batch.each do |block|
            renderer.draw(block)
          end
        elsif block_is_good?(@block)
          super
        end
      end

      def on_kb_f(down)
        toggle_mode if down
      end

      private

      def find_block(bx, by)
        if block = @level.get_block_at_screen(bx, by)
          if block_is_good?(@block) && (block != @block) && mouse_down?
            if !@batch
              @batch_start = @block
            end
          end

          @block = block
          move_to(@block.x, @block.y)

          if @batch_start
            @batch = @level.get_blocks_in_rect(@batch_start, @block).select { |b| block_is_good?(b) }
          end
        else
          @block = nil
          @batch = nil
          @batch_start = nil
          @mouse_down = false
        end
      end

      def block_is_good?(block)
        block && ((@mode == MODE_DIG && block.digable?) || (@mode == MODE_FILL && block.fillable?))
      end

      def job_for_block(block)
        if block_is_good?(block)
          if @mode == MODE_DIG
            @job_factory.dig(block)
          else
            @job_factory.fill(block)
          end
        end
      end

      def work_on_batch
        @batch.each do |block|
          job = job_for_block(block)
          @work_manager.add(job) if job
        end
        @batch = nil
        @batch_start = nil
      end

      def toggle_mode
        if @mode == MODE_DIG
          @mode = MODE_FILL
        else
          @mode = MODE_DIG
        end
      end

    end

  end

end
