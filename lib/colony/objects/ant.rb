require_relative 'entity'
require_relative 'attacker'
require_relative 'healer'

module Colony

  class Ant < Wankel::Movable

    include Entity
    include Attacker
    include Healer

    attr_reader :state

    def initialize
      super(17.0, 17.0, Wankel::ZOrder::PLAYER)
      @color = Gosu::Color::WHITE
    end

    #def init
      #super
      #@speed = rand(30.0..50.0)
      #@damage = rand(1..2)
      #@attack_time = rand(1.0..1.3)
    #end

    def state=(new_state)
      state.exit if state
      @state = new_state
      state.enter
    end

    def update(delta)
      state.update(delta)

      super
    end

  end

end
