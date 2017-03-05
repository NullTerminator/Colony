module Ui
  class Button < UiObject
    attr_accessor :tex_up, :tex_down, :click, :rclick

    def initialize(x, y, tex_up, tex_down=nil, color=nil)
      super(x, y, tex_up, color)
      self.tex_up = tex_up
      self.tex_down = tex_down
    end

    def on_mouse_left(down, x, y)
      click.call if !down && click
    end

    def on_mouse_right(down, x, y)
      rclick.call if !down && rclick
    end

    def on_mouse_over
      super
      self.texture = tex_down if tex_down
    end

    def on_mouse_out
      super
      self.texture = tex_up
    end
  end
end
