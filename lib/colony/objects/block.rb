require 'gosu'

require_relative '../../objects/zorder'
require_relative '../../objects/render_object'

require_relative '../events'

module Colony

  class Block < RenderObject

    SIZE = 25
    COLOR_DIRT = Gosu::Color.argb(0xFF_A0522D)
    COLOR_GRASS = Gosu::Color.argb(0xFF_228B22)
    COLOR_TUNNEL = Gosu::Color.argb(0xFF_00_00_00)

    def initialize
      super(ZOrder::LEVEL)
      @width = @height = SIZE
      fill
    end

    def grassify
      self.extend(Grass)
      @color = COLOR_GRASS
    end

    def fill
      self.extend(Dirt)
      @color = COLOR_DIRT
    end

    def dig
      self.extend(Tunnel)
      @color = COLOR_TUNNEL
    end

  end

  private

  module Dirt
    def is_workable?
      true
    end
  end

  module Grass
    def is_workable?
      false
    end

    def top
      y + height * 0.4
    end
  end

  module Tunnel
    def is_workable?
      false
    end
  end

end
