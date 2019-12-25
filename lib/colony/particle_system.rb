require_relative './objects/particle'

module Colony

  class ParticleSystem

    def initialize
      @effects = []
    end

    def update(delta)
      @effects.each do |effect|
        effect.update(delta)
      end
      @effects.delete_if(&:done?)
    end

    def draw(renderer_fac)
      renderer = renderer_fac.build(Particle)
      @effects.each do |effect|
        effect.particles.each do |p|
          renderer.draw(p)
        end
      end
    end

    def dirt_spray(x, y, angle)
      start_effect(x, y, angle, 1.5, 0xff654321, 19.0, 15, 0.7)
    end

    private

    def start_effect(x, y, angle, size, color, speed, count, duration)
      @effects << ParticleEffect.new(x, y, angle - 60.0, angle + 60.0, size, color, speed, count, duration)
    end

    class ParticleEffect
      attr_reader :particles, :duration

      def initialize(x, y, min_angle, max_angle, size, color, speed, count, duration)
        @duration = duration
        @particles = []

        count.times do
          part_angle = rand(min_angle..max_angle)
          @particles << Particle.new(x, y, part_angle, size, color, speed)
        end
      end

      def update(delta)
        @duration -= delta

        @particles.each do |particle|
          particle.update(delta)
        end
      end

      def done?
        @duration <= 0.0
      end
    end

  end

end
