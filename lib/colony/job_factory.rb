require_relative 'events'
require_relative 'job'

module Colony

  class JobFactory

    def initialize(eventer)
      eventer.register(Events::Work::REMOVED, self)
      @jobs = Hash.new { |h, k| h[k] = Set.new }
    end

    def dig(block)
      cached_job(block, Job::TASK_DIG) || create_job(block, Job::TASK_DIG)
    end

    def fill(block)
      cached_job(block, Job::TASK_FILL) || create_job(block, Job::TASK_FILL)
    end

    def on_work_removed(job)
      @jobs[job.task].delete(job)
    end

    private

    def cached_job(block, task)
      @jobs[task].find { |j| j.block == block }
    end

    def create_job(block, task)
      job = Job.new(block, task)
      @jobs[task] << job
      job
    end

  end

end
