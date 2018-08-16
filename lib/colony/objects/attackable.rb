module Colony

  module Attackable

    attr_reader :max_health, :health

    def init
      super
      regenerate
    end

    # TODO CRM: should this return the amount healed?
    def heal(amount)
      @health += amount
      if health > max_health
        health = max_health
      end
      health
    end

    def regenerate
      @health = max_health
    end

    def is_full_health?
      health == max_health
    end

    def alive?
      health > 0
    end

    def dead?
      health == 0
    end

    # TODO CRM: should this return the damage dealt?
    def attacked(damage)
      @health -= damage
      if @health < 0
        @health = 0
      end
      @health
    end

  end

end
