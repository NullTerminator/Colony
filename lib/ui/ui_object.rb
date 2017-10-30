require_relative '../objects/render_object'

module Ui
  class UiObject < RenderObject
    attr_reader :hover, :mouse_down
    alias :mouse_down? :mouse_down
    alias :hover? :hover

    def initialize
      super(ZOrder::UI)
      @hover = false
    end

    def on_mouse_left(down, x, y)
      if @mouse_down && !down
        left_clicked if respond_to?(:left_clicked)
      end

      @mouse_down = down
    end

    def on_mouse_right(down, x, y)
    end

    def on_mouse_move(x, y, dx, dy)
    end

    def on_mouse_over
      @hover = true
    end

    def on_mouse_out
      @mouse_down = false
      @hover = false
    end
  end
end
