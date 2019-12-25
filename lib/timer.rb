class Timer
  def initialize(interval, &block)
    @interval = interval
    @time = 0.0
    @block = block
  end

  def update(delta)
    @time += delta
    if @time >= @interval
      @block.call
      @time -= @interval
    end
  end
end
