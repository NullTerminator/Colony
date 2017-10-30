require 'gosu'

module Colony

  class AntBehavior

    def initialize(level, ant_repo)
      @level = level
      @ant_repo = ant_repo
      @cache = {}
    end

    def update(delta)
      @ant_repo.all.each do |ant|
        move_like_an_ant(delta, ant)
        keep_in_level(ant)
      end
    end

    private

    def move_like_an_ant(delta, ant)
      if cached = @cache[ant]
        @cache[ant] = cached + delta
        if @cache[ant] <= 4.0
          return
        end
      end

      if rand(2) == 0
        ant.move_left
      else
        ant.move_right
      end
      @cache[ant] = 0.0
    end

    def keep_in_level(ant)
      if ant.left < @level.left
        ant.move_right
      elsif ant.right > @level.right
        ant.move_left
      end
    end

  end
end
