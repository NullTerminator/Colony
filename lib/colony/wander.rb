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
      move_like_an_ant(delta)
      stay_in_level
      look_for_work
    end

    private

    def look_for_work
      if path = @work_manager.get_path_to_closest_block(ant.x, ant.y)
        ant.state = @state_factory.follow_path(ant, path)
      end
    end

    def move_like_an_ant(delta)
      if @move_time
        @move_time -= delta
        if @move_time >= 0.0
          return
        end
      end

      if rand(2) == 0
        ant.move_left
      else
        ant.move_right
      end
      @move_time = rand(3.0..5.0)
    end

    def stay_in_level
      if ant.left < @level.left
        ant.move_right
      elsif ant.right > @level.right
        ant.move_left
      end
    end

  end
end
