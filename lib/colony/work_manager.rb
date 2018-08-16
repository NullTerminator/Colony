require_relative 'events'
require_relative 'path_finder'

module Colony

  class WorkManager

    def initialize(level, eventer)
      @level = level
      @eventer = eventer
      @jobs = Set.new
    end

    def add(job)
      if job.block.workable?
        @jobs << job
        @eventer.trigger(Events::Work::ADDED, job)
      end
    end
    alias :<< :add

    def remove(job)
      @jobs.delete(job)
      @eventer.trigger(Events::Work::REMOVED, job)
    end
    alias :>> :remove

    def toggle(job)
      if @jobs.include?(job)
        remove job
      else
        add job
      end
    end

    def clear
      @jobs.each { |b| @eventer.trigger(Events::Work::REMOVED, b) }
      @jobs = []
    end

    def each_job
      @jobs.each { |b| yield b }
    end

    def count
      @jobs.count
    end

    def get_path_to_job(job, x, y)
      start = @level.get_block_at(x, y)
      if @level.is_reachable?(job.block)
        pf = PathFinder.new(start, job, @level)
        pf.path ? pf : nil
      end
    end

    def get_path_to_closest_job(x, y)
      # TODO CRM: different priority levels on jobs
      start = @level.get_block_at(x, y)
      reachable_jobs.map do |job|
        PathFinder.new(start, job, @level)
      end.select(&:path).sort_by { |p| p.path.length }.first
    end

    private

    def reachable_jobs
      @jobs.select do |job|
        @level.is_reachable?(job.block)
      end
    end

  end
end
