module Colony

  class Job

    TASK_DIG = :dig
    TASK_FILL = :fill

    attr_reader :block, :task, :current_workers, :max_workers

    def initialize(block, task, max_workers=2)
      @block = block
      @task = task
    end

    def is_completed?
    end

  end

end
