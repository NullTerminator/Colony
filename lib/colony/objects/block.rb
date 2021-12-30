require_relative 'attackable'
require_relative '../events'

module Colony

  class Block < Wankel::RenderObject

    include Attackable

    SIZE = 25.0

    attr_reader :digable, :fillable, :walkable

    alias :digable? :digable
    alias :fillable? :fillable
    alias :walkable? :walkable

    def initialize
      super(SIZE, SIZE, Wankel::ZOrder::LEVEL)

      @max_health = 10
    end

    def grassify
      @y = bottom - height * 0.1
      @height = height * 0.2
      @digable = false
      @fillable = false
      @walkable = true
      @type = :grass
      @color = Gosu::Color::WHITE
    end

    def fill
      @digable = true
      @fillable = false
      @walkable = false
      @type = :dirt
      regenerate
      @color = Gosu::Color::WHITE
    end

    def excavate
      @digable = false
      @fillable = true
      @walkable = true
      @type = :tunnel
      @health = 0
      @color = Gosu::Color::BLACK
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
      to_s
    end

  end

end
