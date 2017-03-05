require "singleton"

module System
  class MediaManager
    include Singleton

    def initialize
      @win = Window.instance
      @images = load_images
      @animations = load_animations
      @sounds = load_sounds
      @fonts = load_fonts
    end

    def image(key)
      @images[key]
    end

    def image_from_text(*args)
      Gosu::Image.from_text(@win, *args)
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
        @images["circle_#{radius}".to_sym] ||= Gosu::Image.new(@win, Circle.new(radius), false)
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
      def l(*args)
        args[0] = "media/images/" + args[0]
        Gosu::Image.new(@win, *args)
      end
      {
        #Objects
        player: l("Player.png", false),
        bullet: l("Bullet.png", false),
        seeker: l("Seeker.png", false),
        wanderer: l("Wanderer.png", false),

        background: l("Space.png", true),

        #UI
        load_btn_up: l("IntButtn.bmp", false, 132, 98, 32, 28),
        load_btn_down: l("IntButtn.bmp", false, 169, 98, 32, 28)
      }
    end

    def load_animations
      def l(*args)
        args[0] = "media/images/" + args[0]
        frame_length = args.delete_at(-1)
        [Gosu::Image.load_tiles(@win, *args), frame_length]
      end
      {
        star: l("Star.png", -10, -1, false, 0.1),
      }
    end

    def load_sounds
      def l(*args)
        args[0] = "media/sounds/" + args[0]
        Gosu::Sample.new(@win, *args)
      end
      {
        beep: l("Beep.wav")
      }
    end

    def load_fonts
      def l(*args)
        Gosu::Font.new(@win, *args)
      end
      {
        default: l(Gosu::default_font_name, 18),
        default_large: l(Gosu::default_font_name, 35)
      }
    end
  end
end
