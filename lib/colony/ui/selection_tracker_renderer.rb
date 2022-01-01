module Colony

  module Ui

    class SelectionTrackerRenderer < Wankel::Renderer
      def initialize(window, font)
        @window = window
        @font = font
      end

      def draw(obj, opts={})
        outline_color = Gosu::Color::WHITE
        @window.draw_line(obj.left, obj.top, outline_color, obj.right, obj.top, outline_color, obj.z)
        @window.draw_line(obj.right, obj.top, outline_color, obj.right, obj.bottom, outline_color, obj.z)
        @window.draw_line(obj.right, obj.bottom, outline_color, obj.left, obj.bottom, outline_color, obj.z)
        @window.draw_line(obj.left, obj.bottom, outline_color, obj.left, obj.top, outline_color, obj.z)

        if obj.selected
          obj.texture.draw_rot(
            obj.x - obj.width * 0.3,
            obj.y - obj.height * 0.25,
            obj.z,
            0.0,
            0.5,
            0.5,
            55.0 / obj.texture.width,
            55.0 / obj.texture.height,
            Gosu::Color::WHITE
          )
          @font.draw_text(obj.text, obj.x - obj.width * 0.1, obj.y - obj.height * 0.4, obj.z, 1.0, 1.0, Gosu::Color::WHITE)
        end
      end

    end

  end

end
