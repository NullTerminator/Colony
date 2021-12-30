require_relative 'events'

module Colony

  class UseCases

    def self.init(eventer, input, level, work_manager, job_factory, scrolling_text_manager, particles, block_repo)
      @level = level
      @work_manager = work_manager
      @job_factory = job_factory
      @scrolling_text_manager = scrolling_text_manager
      @particles = particles
      @eventer = eventer
      @block_repo = block_repo

      input.register(:kb_c, self)

      [
        Events::Blocks::DUG,
        Events::Blocks::FILLED,
        Events::Blocks::ATTACKED,

        Events::Camera::MOUSE_LEFT
      ].each do |e|
        eventer.register(e, self)
      end
    end

    def self.on_kb_c(down)
      @work_manager.clear if down
      @job_factory.clear if down
    end

    def self.on_block_dug(block)
      block.excavate
      @level.neighbors(block).select { |b| b.is_grass? }.each(&:excavate)
    end

    def self.on_block_filled(block)
      block.fill
    end

    def self.on_block_attacked(ant, block, damage)
      @scrolling_text_manager.add(damage.to_s, block, Gosu::Color::RED)
      @particles.start_effect(ant.front_x, ant.front_y, ant.angle - 180.0, 1.5, 0xff654321, 19.0, 15, 0.7)
    end

    def self.on_camera_mouse_left(down, mx, my)
      if block = @block_repo.all.find { |a| a.hit?(mx, my) }
        @eventer.trigger(Events::Blocks::CLICKED, block, down)
      end
    end

  end

end
