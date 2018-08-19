require_relative 'ant_state'
require_relative 'events'

module Colony

  class FollowPath < AntState

    attr_reader :path

    def initialize(ant, eventer, path_finder, work_manager, state_factory)
      super(ant, eventer)
      self.path = path_finder
      @work_manager = work_manager
      @state_factory = state_factory
    end

    def path=(new_path_finder)
      @path = new_path_finder.path
      @job = new_path_finder.job
      @target_block = path.last
      @path_index = 1
    end

    def enter
      eventer.register(Events::Work::ADDED, self)
      eventer.register(Events::Work::REMOVED, self)
      eventer.register(Events::Blocks::DUG, self)

      eventer.trigger(Events::Ants::WALK_START, ant)
    end

    def exit
      eventer.unregister(Events::Work::ADDED, self)
      eventer.unregister(Events::Work::REMOVED, self)
      eventer.unregister(Events::Blocks::DUG, self)

      eventer.trigger(Events::Ants::WALK_END, ant)
    end

    def update(delta)
      move_to_next_block
      check_block_collision
    end

    def on_block_dug(block)
      wander_if_target_block block
    end

    def on_block_filled(block)
      wander_if_target_block block
    end

    def on_work_added(work_job)
      if new_path = @work_manager.get_path_to_job(work_job, ant.x, ant.y)
        if new_path.path.length < (path.length - @path_index)
          self.path = new_path
        end
      end
    end

    def on_work_removed(work_job)
      if @job == work_job
        ant.state = @state_factory.wander(ant)
      end
    end

    private

    def wander_if_target_block(block)
      if @target_block == block
        ant.state = @state_factory.wander(ant)
      end
    end

    def check_block_collision
      if next_block && ant.collide?(next_block)
        @path_index += 1
      end
    end

    def move_to_next_block
      if next_block
        ant.look_at(next_block)
        ant.move
      else
        ant.stop
        ant.state = @state_factory.for_job(ant, @job)
      end
    end

    def next_block
      @path[@path_index]
    end

  end
end
