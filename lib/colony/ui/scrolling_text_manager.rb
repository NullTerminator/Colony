module Colony

  module Ui

    class ScrollingTextManager < ::Ui::UiObject
      def initialize
        super()
        @width = @height = 1

        @texts = []
      end

      def update(delta)
        super

        @texts.each { |t| t.update(delta) }
        @texts.delete_if(&:done?)
      end

      def draw(renderer_fac)
        renderer = renderer_fac.build(self.class)
        @texts.each do |st|
          renderer.draw_text(st.text, st.x, st.y, st.color)
        end
      end

      def add(text, target, color)
        x = rand(target.left..target.right)
        @texts << ScrollingText.new(text, x, target.y, color)
      end

      private

      class ScrollingText
        attr_reader :text, :x, :y, :color

        def initialize(text, x, y, color)
          @text = text
          @x = x
          @y = y
          @color = color
          @duration = 1.0
          @vel = rand(20.0..45.0)
        end

        def update(delta)
          @y -= @vel * delta

          @duration -= delta
          if @duration < 0.0
            @duration = 0.0
          end
        end

        def done?
          @duration == 0.0
        end
      end
    end

  end

end
