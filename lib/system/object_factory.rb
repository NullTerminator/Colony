module System
  class ObjectFactory

    def initialize(klass)
      @klass = klass
    end

    def build
      obj = @klass.new
      obj.init
      obj
    end

  end
end
