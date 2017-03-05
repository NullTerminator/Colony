require_relative '../system/object_manager'

module Ui
  class UiManager < System::ObjectManager

    def initialize
      super
      input = System::Input.instance
      input.register(:mouse_move, self)
      input.register(:mouse_left, self)
      input.register(:mouse_right, self)
    end

    def on_mouse_move(x, y, dx, dy)
      objects.each do |o|
        hit = o.hit?(x, y)
        if !o.hover && hit
          o.on_mouse_over
        elsif o.hover && !hit
          o.on_mouse_out
        end
        o.on_mouse_move(x, y, dx, dy)
      end
    end

    def on_mouse_left(down, x, y)
      objects.each do |o|
        if o.hit?(x, y)
          o.on_mouse_left(down, x, y)
        end
      end
    end

    def on_mouse_right(down, x, y)
      objects.each do |o|
        if o.hit?(x, y)
          o.on_mouse_right(down, x, y)
        end
      end
    end

  end
end
