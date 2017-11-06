require_relative '../system/caching_factory'

module Colony

  class AntFactory < System::CachingFactory

    def initialize(state_factory)
      super(Ant)
      @state_fac = state_factory
    end

    def build
      ant = super
      ant.state = @state_fac.wander(ant)
      ant
    end

  end

end
