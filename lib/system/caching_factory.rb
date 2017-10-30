require_relative './object_factory'

module System
  class CachingFactory < ObjectFactory

    def initialize(klass, renderer)
      super
      @cache = []
    end

    def build
      obj = @cache.pop

      if obj
        obj.init
      else
        obj = super
      end

      obj
    end

    def free(obj)
      @cache.push(obj)
      nil
    end

  end
end
