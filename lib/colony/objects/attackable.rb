module Colony

  module Attackable

    def health
      @health ||= 1
    end

    def alive?
      health > 0
    end

    def dead?
      health == 0
    end

    def attacked(damage)
      @health -= damage
    end

  end

end
