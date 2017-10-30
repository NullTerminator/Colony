require 'gosu'

require_relative '../../objects/zorder'
require_relative '../../objects/movable'

module Colony

  class Ant < Movable

    def initialize
      super(ZOrder::PLAYER)
      @color = Gosu::Color::RED
      @width = @height = 7.0
      @speed = rand(13..18)
    end

  end

end
