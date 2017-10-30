require_relative 'events'

module Colony

  class UseCases

    def self.init(eventer, work_manager)
      @work_manager = work_manager

      [Events::Blocks::DUG, Events::Ui::BLOCK_CLICKED].each do |e|
        eventer.register(e, self)
      end
    end

    def self.on_block_clicked(block)
      @work_manager.toggle(block)
    end

    def self.on_block_dug(block)
      # if grass is above this block, break that block
      @work_manager.remove(block)
    end

  end

end
