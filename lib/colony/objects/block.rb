require 'gosu'
require 'state_machines'

require_relative '../../objects/zorder'
require_relative '../../objects/render_object'

require_relative '../main'
require_relative '../events'

module Colony

  class Block < RenderObject

    SIZE = 50

    state_machine do

      state :surface do
        def top
          y + height * 0.4
        end

        def draw
          System::Window.instance
            .draw_quad(left, top, color,
                       right, top, color,
                       right, bottom, color,
                       left, bottom, color,
                       z)
        end
      end

      state :dirt do
        def is_workable?
          true
        end
      end

      state :tunnel do
      end

      state all - [:dirt] do
        def is_workable?
          false
        end
      end

      event :dirtify do
        transition any => :dirt
      end

      event :surfacify do
        transition any => :surface
      end

      event :excavate do
        transition any => :tunnel
      end

      after_transition any => :surface do |block|
        block.color = Gosu::Color.argb(0xFF_228B22)
      end

      after_transition any => :dirt do |block|
        block.color = Gosu::Color.argb(0xFF_A0522D)
      end

      after_transition any => :tunnel do |block|
        #block.color = Gosu::Color.argb(0xFF_80_80_00)
        block.color = Gosu::Color.argb(0xFF_00_00_00)
        Game.instance.events.trigger(Events::Blocks::DUG, block)
      end

      #after_transition on: :excavate do |block|
        #Game.instance.events.trigger(Events::Blocks::DUG, block)
      #end

    end

    def initialize(x, y)
      super(x, y, ZOrder::LEVEL)
      @width = @height = SIZE
      dirtify
    end

  end

end
