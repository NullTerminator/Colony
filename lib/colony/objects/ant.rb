require 'gosu'

require_relative '../../objects/zorder'
require_relative '../../objects/movable'

require_relative 'attacker'
require_relative 'healer'

module Colony

  class Ant < Movable

    include Attacker
    include Healer

    attr_reader :state

    def initialize
      super(ZOrder::PLAYER)
      @width = @height = 17.0
      @color = Gosu::Color::WHITE
    end

    def init
      super
      @speed = rand(30.0..50.0)
      @damage = 1
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
