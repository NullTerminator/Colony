require 'gosu'

require_relative '../../objects/zorder'
require_relative '../../objects/render_object'

require_relative 'attackable'
require_relative '../events'

module Colony

  class Block < RenderObject

    include Attackable

    SIZE = 25.0
    COLOR_DIRT = Gosu::Color.argb(0xFF_A0522D)
    COLOR_GRASS = Gosu::Color.argb(0xFF_228B22)
    COLOR_TUNNEL = Gosu::Color.argb(0xFF_00_00_00)

    attr_reader :workable, :walkable, :health

    alias :workable? :workable
    alias :walkable? :walkable

    def initialize
      super(ZOrder::LEVEL)
      @width = @height = SIZE
      @health = 10
    end

    def init
      super
      fill
      self
    end

    def grassify
      @y = bottom - height * 0.1
      @height = height * 0.2
      @workable = false
      @walkable = true
      @color = COLOR_GRASS
      @type = :grass
    end

    def fill
      @workable = true
      @walkable = false
      @color = COLOR_DIRT
      @type = :dirt
    end

    def excavate
      @workable = false
      @walkable = true
      @color = COLOR_TUNNEL
      @type = :tunnel
    end

    def is_grass?
      @type == :grass
    end

    def is_dirt?
      @type == :dirt
    end

    def is_tunnel?
      @type == :tunnel
    end

    def to_s
      "Block: #{x.to_i}:#{y.to_i}"
    end

    def inspect
      "Block: #{x.to_i}:#{y.to_i}"
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
