module Colony

  class PathFinder

    def initialize(start, target, level)
      @start = start
      @target = target
      @level = level
    end

    def path
      been_there = {}
      pq = PriorityQueue.new
      pq << [1, [@start, [], 0]]

      while !pq.empty?
        spot, path_so_far, cost_so_far = pq.next
        next if been_there[spot]

        new_path = path_so_far + [spot]
        if spot == @target
          return new_path
        end

        been_there[spot] = true

        @level.neighbors(spot).each do |block|
          next unless block.is_tunnel? || block.is_grass? || block == @target
          next if been_there[block]

          new_cost = cost_so_far + 1

          pq << [new_cost + distance_to_target(block), [block, new_path, new_cost]]
        end
      end

      nil
    end

    private

    def distance_to_target(block)
      (block.y - @target.y).abs + (block.x - @target.x).abs
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

      def <<(pritem)
        add(*pritem)
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
