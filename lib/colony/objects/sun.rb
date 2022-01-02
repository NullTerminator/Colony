require_relative 'celestial'

module Colony

  class Sun < Celestial

    SIZE = 150

    def initialize(media)
      super(SIZE)
      @texture = media.image(:sun)
      @color = Gosu::Color::WHITE
    end

  end

end
