module Colony

  module Ui

    class AntCountRenderer < Wankel::Renderer
      def initialize(texture_renderer, font_renderer)
        @texture_renderer = texture_renderer
        @font_renderer = font_renderer
      end

      def draw(obj, opts={})
        @texture_renderer.draw(obj, x_offset: -(obj.width * 0.35), y_offset: obj.height * 0.30)
        @font_renderer.draw(obj)
      end

    end

  end

end
