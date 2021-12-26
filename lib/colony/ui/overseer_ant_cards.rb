module Colony
  module Ui
    class OverseerAntCards < Wankel::Ui::UiObject

      PER_ROW = 7.0
      HEIGHT = 200.0
      TOP_MARGIN = 100.0
      SIDE_MARGIN = 30.0
      CARD_MARGIN = 10.0

      def initialize(input, media, window, font)
        super(1, 1)
        @window = window
        @font = font
        @texture = media.image(:ant)

        @ants = []
      end

      def add(ant_data)
        @ants << FakeAnt.new(ant_data)
      end

      def draw(fac)
        # Hack hack hack yuck
        @ants.each.with_index do |ant, i|
          draw_card(ant, i)
        end
      end

      def draw_card(ant, i)
        row, col = i.divmod(PER_ROW)

        width = (@window.width - (SIDE_MARGIN * 2) - (CARD_MARGIN * (PER_ROW - 1))) / PER_ROW
        left = SIDE_MARGIN + col * width + CARD_MARGIN * col
        right = left + width
        top = TOP_MARGIN + row * HEIGHT + CARD_MARGIN * row
        bottom = top + HEIGHT
        outline_color = Gosu::Color::WHITE

        @window.draw_line(left, top, outline_color, right, top, outline_color, Wankel::ZOrder::UI)
        @window.draw_line(right, top, outline_color, right, bottom, outline_color, Wankel::ZOrder::UI)
        @window.draw_line(right, bottom, outline_color, left, bottom, outline_color, Wankel::ZOrder::UI)
        @window.draw_line(left, bottom, outline_color, left, top, outline_color, Wankel::ZOrder::UI)

        @texture.draw(
          left + width * 0.5 - @texture.width * 0.25,
          top + 15,
          Wankel::ZOrder::UI,
          0.5,
          0.5,
          Gosu::Color::WHITE
        )

        @font.draw_text("ANT: #{ant.id}", left + 40, top + 70, Wankel::ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
        @font.draw_text("DAMAGE: #{ant.damage}", left + 40, top + 90, Wankel::ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        @font.draw_text("SPEED: #{ant.speed.truncate(2)}", left + 40, top + 110, Wankel::ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        @font.draw_text("ATTACK SPEED: #{ant.attack_speed.truncate(2)}", left + 40, top + 130, Wankel::ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
      end

      private

      class FakeAnt
        attr_reader :id, :speed, :damage, :attack_speed

        def initialize(data)
          @id = data['id']
          @speed = data['speed']
          @damage = data['damage']
          @attack_speed = data['attack_speed']
        end
      end

    end
  end
end
