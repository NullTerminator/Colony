module Colony

  class Job

    TASK_DIG = :dig
    TASK_FILL = :fill

    attr_reader :ants, :block, :task, :max_workers

    def initialize(block, task, max_workers=2)
      @block = block
      @task = task
      @max_workers = max_workers
      @ants = []
    end

    def add(ant)
      return false if is_full?

      @ants << ant
    end

    def is_working?(ant)
      @ants.include?(ant)
    end

    def needs_work?
      @ants.count < max_workers
    end

    def is_full?
      @ants.count == max_workers
    end

  end

end
