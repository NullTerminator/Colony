require_relative '../system/caching_factory'
require_relative 'events'

module Colony

  class AntFactory < System::CachingFactory

    def initialize(state_factory, media, eventer)
      super(Ant)

      @state_fac = state_factory
      @eventer = eventer
      @media = media
      @next_id = 1
    end

    def build
      ant = super
      ant.id = @next_id
      @next_id += 1

      ant.speed = rand(30.0..50.0)
      ant.damage = rand(1..2)
      ant.attack_time = rand(1.0..1.3)
      ant.state = @state_fac.wander(ant)
      ant.texture = @media.image(:ant)

      @eventer.trigger(Events::Ants::SPAWNED, ant)

      ant
    end

  end

end
