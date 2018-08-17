require_relative '../../ui/ui_object'

require_relative '../objects/block'
require_relative '../events'

module Colony

  module Ui

    class BlockSelector < ::Ui::UiObject

      MODE_DIG = :dig
      MODE_FILL = :fill

      def initialize(level, work_manager, job_factory, input)
        super()
        @width = @height = Block::SIZE
        @color = Gosu::Color::WHITE

        @mode = MODE_DIG
        @batch_start = nil
        @batch = nil
        @block = nil

        @level = level
        @work_manager = work_manager
        @job_factory = job_factory

        input.register(:kb_f, self)
      end

      def left_clicked
        unless @batch
          job = job_for_block(@block)
          @work_manager.toggle(job) if job
        end
      end

      def on_mouse_left(down, x, y)
        super

        if @batch && !down
          work_on_batch
          @batch = nil
          @batch_start = nil
        end
      end

      def on_mouse_right(down, x, y)
        @batch = nil
        @batch_start = nil
        @block = nil
      end

      def on_mouse_move(mx, my, dx, dy)
        block = @level.get_block_at(mx, my)
        if block
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
        end
      end

      def on_mouse_out
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
