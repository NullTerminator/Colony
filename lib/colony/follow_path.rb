require_relative 'ant_state'
require_relative 'events'

module Colony

  class FollowPath < AntState

    attr_reader :path

    def initialize(ant, eventer, path, work_manager, state_factory)
      super(ant, eventer)
      self.path = path
      @work_manager = work_manager
      @state_factory = state_factory
    end

    def path=(new_path)
      @path = new_path
      @target_block = path.last
      @path_index = 1
    end

    def enter
      eventer.register(Events::Work::ADDED, self)
      eventer.register(Events::Blocks::DUG, self)
      eventer.register(Events::Work::REMOVED, self)
    end

    def exit
      eventer.unregister(Events::Blocks::DUG, self)
      eventer.unregister(Events::Work::ADDED, self)
      eventer.unregister(Events::Work::REMOVED, self)
    end

    def update(delta)
      move_to_next_block
      check_block_collision
    end

    def on_block_dug(block)
      if @target_block == block
        ant.state = @state_factory.wander(ant)
      end
    end

    def on_work_added(block)
      if new_path = @work_manager.get_path_to_block(block, ant.x, ant.y)
        if new_path.length < (path.length - @path_index)
          self.path = new_path
        end
      end
    end

    def on_work_removed(block)
      if @target_block == block
        ant.state = @state_factory.wander(ant)
      end
    end

    private

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
        ant.state = @state_factory.dig_block(ant, @target_block)
      end
    end

    def next_block
      @path[@path_index]
    end

  end
end
