require_relative '../system/caching_factory'
require_relative 'events'

module Colony

  class AntFactory < System::CachingFactory

    def initialize(state_factory, eventer)
      super(Ant)

      @state_fac = state_factory
      @eventer = eventer
    end

    def build
      ant = super
      ant.state = @state_fac.wander(ant)

      @eventer.trigger(Events::Ants::SPAWNED, ant)

      ant
    end

  end

end
