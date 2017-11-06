require_relative 'wander'
require_relative 'follow_path'
require_relative 'dig_block'

module Colony

  class AntStateFactory

    def initialize(level, work_manager, eventer)
      @level = level
      @work_manager = work_manager
      @eventer = eventer
    end

    def wander(ant)
      Wander.new(ant, @eventer, @level, @work_manager, self)
    end

    def follow_path(ant, path)
      FollowPath.new(ant, @eventer, path, @work_manager, self)
    end

    def dig_block(ant, block)
      DigBlock.new(ant, @eventer, block, self)
    end

  end

end
