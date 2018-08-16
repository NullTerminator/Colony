module Colony

  class Healable

    # TODO CRM: should this return the amount healed?
    def heal(amount)
      health += amount
      if health > max_health
        health = max_health
      end
      health
    end

  end

end
