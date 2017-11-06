module Colony

  class AntState

    attr_reader :ant, :eventer

    def initialize(ant, eventer)
      @ant = ant
      @eventer = eventer
    end

    def enter
    end

    def exit
    end

  end
end
