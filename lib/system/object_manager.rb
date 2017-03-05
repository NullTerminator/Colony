module System
  class ObjectManager

    attr_reader :objects

    def initialize
      @objects = []
    end

    def add(obj)
      objects << obj
    end
    alias :<< :add

    def add_after(i_obj, obj)
      objects.insert(objects.index(i_obj), obj)
    end

    def remove(obj)
      objects.delete(obj)
    end
    alias :>> :remove

    def update(delta)
      objects.each { |obj| obj.update(delta) }
    end

    def draw
      objects.each(&:draw)
    end

    def total_objects
      all = objects.length

      objects.each do |object|
        all += object.total_objects if object.respond_to?(:total_objects)
      end

      all
    end
  end
end
