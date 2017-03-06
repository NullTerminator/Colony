require_relative 'main'
require_relative 'work_manager'

module Colony

  class UseCases

    def self.init
      %w(block_clicked block_dug).each { |e| register(e) }
    end

    def self.on_block_clicked(block)
      WorkManager.instance.toggle block
    end

    def self.on_block_dug(block)
      # if grass is above this block, break that block
    end

    private

    def self.register(event)
      Game.instance.events.register(event.to_sym, self)
    end

  end

end
