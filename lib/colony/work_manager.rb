require 'singleton'

require_relative 'main'
require_relative 'events'

module Colony

  class WorkManager

    include Singleton

    def initialize
      @blocks = []

      # on dirt broke event remove the block since work is done
      Game.instance.events.register(Events::Blocks::DUG, self)
      #Game.instance.events.register(Events::Blocks::DUG, ->(block) {
        #remove(block)
      #})
    end

    def add(block)
      @blocks << block if block.is_workable?
    end
    alias :<< :add

    def remove(block)
      @blocks.delete(block)
    end
    alias :>> :remove

    def toggle(block)
      if @blocks.include?(block)
        remove block
      else
        add block
      end
    end

    def each_block
      @blocks.each { |b| yield b }
    end

    # return a block to work on
    def get_closest_block(x, y)
    end

    def on_block_dug(block)
      remove(block)
    end

  end
end
