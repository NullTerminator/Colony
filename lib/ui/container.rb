require_relative '../system/object_manager'

module Ui
  class Container < UiObject
    def initialize(x, y)
      super
      @object_manager = System::ObjectManager.new
    end

    def objects
      @object_manager.objects
    end

    def add(obj)
      @object_manager << obj
    end
    alias :<< :add

    def add_after(i_obj, obj)
      @object_manager.add_after(i_obj, obj)
    end

    def remove(obj)
      @object_manager.delete(obj)
    end
    alias :>> :remove

    def update(delta)
      @object_manager.update(delta) if visible
    end

    def draw
      super
      @object_manager.draw if visible
    end

    def total_objects
      all = objects.length

      objects.each do |object|
        all += object.total_objects if object.respond_to?(:total_objects)
      end

      all
    end

    def on_mouse_move(x, y, dx, dy)
      return unless visible

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
      return unless visible

      objects.each do |o|
        if o.hit?(x, y)
          o.on_mouse_left(down, x, y)
        end
      end
    end

    def on_mouse_right(down, x, y)
      return unless visible

      objects.each do |o|
        if o.hit?(x, y)
          o.on_mouse_right(down, x, y)
        end
      end
    end
  end
end
