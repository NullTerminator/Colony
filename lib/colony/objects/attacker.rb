module Colony

  module Attacker

    def damage
      @damage || 1
    end

    def attack_time
      @attack_time ||= 0.13
    end

    def attack(target)
      target.attacked(damage)
    end

  end

end
