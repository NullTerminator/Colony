require_relative 'events'

module Colony

  class UseCases

    def self.init(eventer, input, work_manager)
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
      # if grass is above this block, break that block
      @work_manager.remove(block)
    end

  end

end
