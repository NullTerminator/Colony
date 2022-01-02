module Colony

  class Celestial < Wankel::RenderObject

    ROTATION_TIME = 60.0 * 5.0

    def initialize(size)
      super(size, size, Wankel::ZOrder::BG)

      @time = 0.0
      @start_angle = 0.0
    end

    def update(delta)
      super

      @time += delta

      if @time > ROTATION_TIME
        @time -= ROTATION_TIME
      end

      @angle = @start_angle + (@time / ROTATION_TIME) * 360.0
      @angle *= -1

      @x = Gosu.offset_x(angle, 1400)
      @y = Gosu.offset_y(angle, 600)
    end

    def draw(renderer_fac)
      renderer = renderer_fac.build(self.class)
      renderer.draw(self, angle: 0)
    end

  end

end
