module System
  class Animation
    attr_accessor :frame, :time
    attr_reader :frames, :frame_length

    def initialize(frames, frame_length)
      @frames = frames
      @frame_length = frame_length
      @frame = 0
      @time = 0.0
    end

    def update(delta)
      self.time += delta
      if time >= frame_length
        self.time -= frame_length
        self.frame += 1
        self.frame -= frames.size if frame == frames.size
      end
    end

    def draw_rot(*args)
      frames[frame].draw_rot(*args)
    end

    def width
      frames.first.width
    end

    def height
      frames.first.height
    end
  end
end
