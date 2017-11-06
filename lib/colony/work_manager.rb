require_relative 'events'
require_relative 'path_finder'

module Colony

  class WorkManager

    def initialize(level, eventer)
      @level = level
      @eventer = eventer
      @blocks = []
    end

    def add(block)
      if block.workable?
        @blocks << block
        @eventer.trigger(Events::Work::ADDED, block)
      end
    end
    alias :<< :add

    def remove(block)
      @blocks.delete(block)
      @eventer.trigger(Events::Work::REMOVED, block)
    end
    alias :>> :remove

    def toggle(block)
      if @blocks.include?(block)
        remove block
      else
        add block
      end
    end

    def clear
      @blocks.each { |b| @eventer.trigger(Events::Work::REMOVED, b) }
      @blocks = []
    end

    def each_block
      @blocks.each { |b| yield b }
    end

    def get_path_to_block(block, x, y)
      start = @level.get_block_at(x, y)
      if @level.is_reachable?(block)
        PathFinder.new(start, block, @level).path
      end
    end

    def get_path_to_closest_block(x, y)
      start = @level.get_block_at(x, y)
      reachable_blocks.map do |block|
        PathFinder.new(start, block, @level).path
      end.compact.sort_by(&:length).first
    end

    private

    def reachable_blocks
      @blocks.select do |block|
        @level.is_reachable?(block)
      end
    end

  end
end
