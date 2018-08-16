module Colony

  class PathFinder

    attr_reader :job

    def initialize(start, job, level)
      @start = start
      @job = job
      @level = level
      @found_path = nil
    end

    def path
      return @found_path if @found_path

      been_there = {}
      pq = PriorityQueue.new
      pq << [1, [@start, [], 0]]

      while !pq.empty?
        spot, path_so_far, cost_so_far = pq.next
        next if been_there[spot]

        new_path = path_so_far + [spot]
        if spot == @job.block
          return @found_path = new_path
        end

        been_there[spot] = true

        @level.neighbors(spot).each do |block|
          next unless block.is_tunnel? || block.is_grass? || block == @job.block
          next if been_there[block]

          new_cost = cost_so_far + 1

          pq << [new_cost + distance_to_target(block), [block, new_path, new_cost]]
        end
      end

      nil
    end

    private

    def distance_to_target(block)
      (block.y - @job.block.y).abs + (block.x - @job.block.x).abs
    end

    class PriorityQueue
      def initialize
        @list = []
      end

      def add(priority, item)
        @list << [priority, item]
        @list.sort! { |x, y| x.first <=> y.first }
        self
      end

      def <<(item)
        add(*item)
      end

      def next
        @list.shift[1]
      end

      def empty?
        @list.empty?
      end
    end

  end
end
