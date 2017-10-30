require 'gosu'

require_relative 'animation'

module System
  class MediaManager

    def initialize
      @images = load_images
      @animations = load_animations
      @sounds = load_sounds
      @fonts = load_fonts
    end

    def image(key)
      @images[key]
    end

    def image_from_text(*args)
      Gosu::Image.from_text(*args)
    end

    def animation(key)
      Animation.new(@animations[key][0], @animations[key][1])
    end

    def sound(key)
      @sounds[key]
    end

    def font(key)
      @fonts[key]
    end

    def circle(radius)
      radius = radius.to_i
      if radius > 0
        @images["circle_#{radius}".to_sym] ||= Gosu::Image.new(Circle.new(radius), false)
      end
    end

    private

    class Circle
      attr_reader :columns, :rows

      def initialize radius
        @columns = @rows = radius * 2
        lower_half = (0...radius).map do |y|
          x = Math.sqrt(radius**2 - y**2).round
          right_half = "#{"\xff" * x}#{"\x00" * (radius - x)}"
          "#{right_half.reverse}#{right_half}"
        end.join
        @blob = lower_half.reverse + lower_half
        @blob.gsub!(/./) { |alpha| "\xff\xff\xff#{alpha}"}
      end

      def to_blob
        @blob
      end
    end

    def load_images
      def l(source, options={})
        Gosu::Image.new("media/images/#{source}", options)
      end
      {
        #Objects
        #player: l("Player.png"),
        #bullet: l("Bullet.png"),
        #seeker: l("Seeker.png"),
        #wanderer: l("Wanderer.png"),

        #background: l("Space.png", tileable: true),

        #UI
        #load_btn_up: l("IntButtn.bmp", tileable: false, rect: [132, 98, 32, 28]),
        #load_btn_down: l("IntButtn.bmp", tileable: false, rect: [169, 98, 32, 28])
      }
    end

    def load_animations
      def l(source, width, height, frame_length, options={})
        [Gosu::Image.load_tiles("media/images/#{source}", width, height), frame_length]
      end
      {
        star: l("Star.png", -10, -1, 0.1),
      }
    end

    def load_sounds
      def l(*args)
        args[0] = "media/sounds/" + args[0]
        Gosu::Sample.new(*args)
      end
      {
        beep: l("Beep.wav")
      }
    end

    def load_fonts
      def l(name, height)
        Gosu::Font.new(height, name: name)
      end
      {
        default: l(Gosu::default_font_name, 18),
        default_large: l(Gosu::default_font_name, 35)
      }
    end
  end
end
