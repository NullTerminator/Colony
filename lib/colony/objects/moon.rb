require_relative 'celestial'

module Colony

  class Moon < Celestial

    SIZE = 135

    def initialize(media)
      super(SIZE)
      @texture = media.image(:moon)
      @color = Gosu::Color::WHITE
      @start_angle = 180.0
    end

  end

end
