require 'gosu'

require_relative '../../objects/zorder'
require_relative '../../objects/render_object'

require_relative 'attackable'
require_relative '../events'

module Colony

  class Block < RenderObject

    include Attackable

    SIZE = 25.0

    attr_reader :digable, :fillable, :walkable

    alias :digable? :digable
    alias :fillable? :fillable
    alias :walkable? :walkable

    def initialize
      super(ZOrder::LEVEL)
      @width = @height = SIZE
      @color = Gosu::Color::WHITE

      @max_health = 10
    end

    def grassify
      @y = bottom - height * 0.1
      @height = height * 0.2
      @digable = false
      @fillable = false
      @walkable = true
      @type = :grass
      show
    end

    def fill
      @digable = true
      @fillable = false
      @walkable = false
      @type = :dirt
      regenerate
      show
    end

    def excavate
      @digable = false
      @fillable = true
      @walkable = true
      hide
      @type = :tunnel
      @health = 0
    end

    def workable?
      digable? || fillable?
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

end
