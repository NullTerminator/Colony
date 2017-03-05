module Game
  class Enemy < Movable
    def initialize
      super
      @z = ZOrder::ENEMIES
    end

    def kill
      Game.instance.events.trigger(:enemy_killed, @score_value)
      Game.instance.enemies >> self
      super
    end

  end
end
