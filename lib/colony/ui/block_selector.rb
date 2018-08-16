require_relative '../../ui/ui_object'

require_relative '../objects/block'
require_relative '../events'

module Colony

  module Ui

    class BlockSelector < ::Ui::UiObject

      MODE_DIG = :dig
      MODE_FILL = :fill

      def initialize(level, work_manager, job_factory, eventer, input)
        super()
        @width = @height = Block::SIZE
        @color = Gosu::Color::WHITE

        @mode = MODE_DIG
        #@batch = {}

        @level = level
        @eventer = eventer
        @work_manager = work_manager
        @job_factory = job_factory

        input.register(:kb_f, self)
      end

      def left_clicked
        if block_is_good?
          @eventer.trigger(Events::Ui::BLOCK_SELECTED, @block)
          if @mode == MODE_DIG
            job = @job_factory.dig(@block)
          else
            job = @job_factory.fill(@block)
          end
          @work_manager.toggle(job)
        end
      end

      def on_mouse_move(mx, my, dx, dy)
        if @block = @level.get_block_at(mx, my)
          move_to(@block.x, @block.y)

          #if mouse_down? && !@batch[@block]
            #@batch[@block] = true
            #@eventer.trigger(Events::Ui::BLOCK_SELECTED, @block)
          #end
        end
      end

      #def on_mouse_out
      #end

      def draw(renderer_fac)
        super if block_is_good?
      end

      def on_kb_f(down)
        toggle_mode if down
      end

      private

      def block_is_good?
        @block && ((@mode == MODE_DIG && @block.digable?) || (@mode == MODE_FILL && @block.fillable?))
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
