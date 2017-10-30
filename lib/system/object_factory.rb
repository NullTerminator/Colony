module System
  class ObjectFactory

    def initialize(klass, renderer)
      @klass = klass
      klass.renderer = renderer
    end

    def build
      obj = @klass.new
      obj.init
    end

  end
end
