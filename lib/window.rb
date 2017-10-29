require "singleton"
require "gosu"

module System
  class Window < Gosu::Window
    include Singleton

    def initialize
      super 1920, 1080, false
      self.caption = "Game"
    end

    def needs_cursor?
      true
    end

    def update
      Game.instance.update
    end

    def draw
      Game.instance.draw
    end

    def button_down(id)
      Input.instance.button(id, true)
    end

    def button_up(id)
      Input.instance.button(id, false)
    end

    def width
      super.to_f
    end

    def height
      super.to_f
    end
  end
end
