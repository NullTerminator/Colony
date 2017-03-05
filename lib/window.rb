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
      Float(super)
    end

    def height
      Float(super)
    end
  end
end
