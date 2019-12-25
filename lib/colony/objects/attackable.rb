module Colony

  module Attackable

    attr_reader :max_health, :health

    def init
      super
      regenerate
    end

    def heal(amount)
      pre_heal = @health
      @health += amount

      if health > max_health
        health = max_health
      end

      @health - pre_heal
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

    def attacked(damage)
      pre_damage = @health
      @health -= damage

      if @health < 0
        @health = 0
      end

      pre_damage - @health
    end

  end

end
