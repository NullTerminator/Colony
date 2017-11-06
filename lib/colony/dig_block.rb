require_relative 'ant_state'
require_relative 'events'

module Colony

  class DigBlock < AntState

    attr_reader :target_block

    def initialize(ant, eventer, block, state_factory)
      super(ant, eventer)
      @target_block = block
      @state_factory = state_factory
    end

    def enter
      @attack_time = 0.0
      eventer.register(Events::Blocks::DUG, self)
      eventer.register(Events::Work::REMOVED, self)
    end

    def exit
      eventer.unregister(Events::Blocks::DUG, self)
      eventer.unregister(Events::Work::REMOVED, self)
    end

    def update(delta)
      attack_target(delta)
    end

    def on_block_dug(block)
      if @target_block == block
        ant.state = @state_factory.wander(ant)
      end
    end

    def on_work_removed(block)
      if @target_block == block
        ant.state = @state_factory.wander(ant)
      end
    end

    private

    def attack_target(delta)
      @attack_time -= delta
      if @attack_time > 0.0
        return
      end
      @attack_time = ant.attack_time

      ant.attack(@target_block)

      if @target_block.dead?
        @eventer.trigger(Events::Blocks::DUG, @target_block)
      end
    end

  end
end
