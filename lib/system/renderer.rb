module System
  class Renderer

    attr_reader :child

    def initialize(window)
      @window = window
    end

    def add(renderer)
      if child
        child.add(renderer)
      else
        @child = renderer
      end
    end

    def draw(obj, opts={})
      if child
        child.draw(obj)
      end
    end

  end
end
