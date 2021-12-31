require_relative 'entity'
require_relative 'attacker'
require_relative 'healer'

module Colony

  class Ant < Wankel::Movable

    SIZE = 17.0

    include Entity
    include Attacker
    include Healer

    attr_reader :state

    def initialize
      super(SIZE, SIZE, Wankel::ZOrder::PLAYER)
      @color = Gosu::Color::WHITE
    end

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
