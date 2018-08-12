require_relative 'ant_state'

module Colony

  class Wander < AntState

    attr_reader :ant

    def initialize(ant, eventer, level, work_manager, state_factory)
      super(ant, eventer)
      @level = level
      @work_manager = work_manager
      @state_factory = state_factory
    end

    def update(delta)
      if !@target_x || ant.close_enough_to?(@target_x, @target_y)
        move_like_an_ant
      end

      if @target_x
        ant.look_at_pos(@target_x, @target_y)
        ant.move
      end

      look_for_work
    end

    private

    def move_like_an_ant
      block = @level.get_block_at(ant.x, ant.y)
      blocks = @level.neighbors(block) << block
      target = blocks.select { |b| b.walkable? }.sample
      @target_x = rand(target.left..target.right)
      @target_y = rand(target.top..target.bottom)
    end

    def look_for_work
      if path = @work_manager.get_path_to_closest_block(ant.x, ant.y)
        ant.state = @state_factory.follow_path(ant, path)
      end
    end

  end
end
