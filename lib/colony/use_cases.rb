require_relative 'events'

module Colony

  class UseCases

    def self.init(eventer, input, level, work_manager, job_factory, scrolling_text_manager, particles)
      @level = level
      @work_manager = work_manager
      @job_factory = job_factory
      @scrolling_text_manager = scrolling_text_manager
      @particles = particles

      input.register(:kb_c, self)

      [Events::Blocks::DUG, Events::Blocks::FILLED, Events::Blocks::ATTACKED].each do |e|
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
      @particles.dirt_spray(ant.front_x, ant.front_y, ant.angle - 180.0)
    end

  end

end
