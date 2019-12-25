require_relative '../../timer'
require_relative '../ant_state'
require_relative '../events'

module Colony

  class DigBlock < AntState

    def initialize(ant, eventer, work_manager, job, state_factory)
      super(ant, eventer)
      @job = job
      @target_block = job.block
      @state_factory = state_factory
      @work_manager = work_manager
    end

    def enter
      @dig_timer = Timer.new(ant.attack_time) { attack_target }
      eventer.register(Events::Blocks::DUG, self)
      eventer.register(Events::Work::REMOVED, self)

      eventer.trigger(Events::Ants::DIG_START, ant)
    end

    def exit
      eventer.unregister(Events::Blocks::DUG, self)
      eventer.unregister(Events::Work::REMOVED, self)

      eventer.trigger(Events::Ants::DIG_END, ant)
    end

    def update(delta)
      @dig_timer.update(delta)
    end

    def on_block_dug(block)
      if @target_block == block
        ant.state = @state_factory.wander(ant)
      end
    end

    def on_work_removed(job)
      if @job == job
        ant.state = @state_factory.wander(ant)
      end
    end

    private

    def attack_target
      damage = ant.attack(@target_block)
      @eventer.trigger(Events::Blocks::ATTACKED, @target_block, damage)

      if @target_block.dead?
        @eventer.trigger(Events::Blocks::DUG, @target_block)
        @work_manager.remove(@job)
      end
    end

  end
end
