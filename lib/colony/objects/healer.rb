module Colony

  module Healer

    def heal_amount
      @heal_amount || 1
    end

    # TODO CRM: should this return the amount healed?
    def heal(target)
      target.heal(heal_amount)
    end

  end
end
