require 'gosu'

require_relative '../../objects/zorder'
require_relative '../../objects/movable'

module Colony

  class Ant < Movable

    def initialize
      super(ZOrder::PLAYER)
      @color = Gosu::Color::RED
      @width = @height = 7
      @speed = 7.0
    end

  end

end
