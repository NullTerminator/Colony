module Colony

  module Attacker

    attr_writer :damage, :attack_time

    def damage
      @damage || 1
    end

    def attack_time
      @attack_time ||= 1.0
    end

    def attack(target)
      target.attacked(damage)
    end

  end

end
