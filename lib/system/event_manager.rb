require 'set'

module System
  class EventManager

    def initialize
      @events = Hash.new { |h, k| h[k] = Set.new }
    end

    def register(events, obj)
      Array(events).each do |event|
        @events[event.to_sym] << obj
      end
    end

    def unregister(events, obj)
      Array(events).each do |event|
        @events[event.to_sym].delete(obj)
      end
    end

    def trigger(event, *args)
      event = event.to_sym
      @events[event].each do |reg|
        if reg.respond_to?(:call)
          reg.call(*args)
        else
          reg.public_send("on_#{event}", *args)
        end
      end
    end
  end
end
