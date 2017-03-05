module System
  module Color

    def self.rgba(r, g, b, a = 255)
      Gosu::Color.new( (a << 24) | (b << 16) | (g << 8) | r)
    end

  end
end
