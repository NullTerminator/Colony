require_relative 'jobs/wander'
require_relative 'jobs/follow_path'
require_relative 'jobs/dig_block'
require_relative 'jobs/fill_block'

require_relative 'jobs/job'

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

    def dig_block(ant, job)
      DigBlock.new(ant, @eventer, @work_manager, job, self)
    end

    def fill_block(ant, job)
      FillBlock.new(ant, @eventer, @work_manager, job, self)
    end

    def for_job(ant, job)
      case job.task
      when Job::TASK_DIG
        dig_block(ant, job)
      when Job::TASK_FILL
        fill_block(ant, job)
      end
    end

  end

end
