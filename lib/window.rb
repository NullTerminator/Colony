require "gosu"

module System
  class Window < Gosu::Window

    def initialize(game)
      super 1920, 1080, false
      self.caption = "Game"
      @game = game
    end

    #def needs_cursor?
      #true
    #end

    def update
      @game.update
    end

    def draw
      @game.draw
    end

    def button_down(id)
      @game.button(id, true)
    end

    def button_up(id)
      @game.button(id, false)
    end

    def width
      super.to_f
    end

    def height
      super.to_f
    end
  end
end
