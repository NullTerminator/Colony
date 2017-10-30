module System
  class ObjectRepository

    def initialize
      @objects = []
    end

    def add(obj)
      @objects << obj
    end
    alias :<< :add

    def add_after(i_obj, obj)
      @objects.insert(objects.index(i_obj), obj)
    end

    def remove(obj)
      @objects.delete(obj)
    end
    alias :>> :remove

    def all
      @objects
    end

    def method_missing(m, *args)
      meth = m.id2name
      if meth.start_with?("find_by_")
        attr = meth.slice(8..-1)
        find_by_attr(attr, args.first)
      elsif meth.start_with?("find_all_by_")
        attr = meth.slice(12..-1)
        find_all_by_attr(attr, args.first)
      else
        super
      end
    end

    private

    def find_by_attr(attr, val)
      @objects.find do |o|
        o.public_send(attr) == val
      end
    end

    def find_all_by_attr(attr, val)
      @objects.select do |o|
        o.public_send(attr) == val
      end
    end

  end
end
