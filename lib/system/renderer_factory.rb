module System
  class RendererFactory

    def initialize
      @renderer_map = {}
    end

    def register(key, renderer_class)
      @renderer_map[key] = renderer_class
    end

    def build(key)
      unless renderer = @renderer_map[key]
        raise "NO RENDERER REGISTERED FOR: #{key}"
      end
      renderer
    end

  end
end
