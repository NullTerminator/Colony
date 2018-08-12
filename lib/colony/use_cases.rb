require_relative 'events'

module Colony

  class UseCases

    def self.init(eventer, input, level, work_manager)
      @level = level
      @work_manager = work_manager

      input.register(:kb_c, self)

      [Events::Blocks::DUG, Events::Ui::BLOCK_SELECTED].each do |e|
        eventer.register(e, self)
      end
    end

    def self.on_kb_c(down)
      @work_manager.clear if down
    end

    def self.on_block_selected(block)
      @work_manager.toggle(block)
    end

    def self.on_block_dug(block)
      block.excavate
      @work_manager.remove(block)
      @level.neighbors(block).select { |b| b.is_grass? }.each(&:excavate)
    end

  end

end
