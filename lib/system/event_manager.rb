module System
  class EventManager

    def initialize
      @events = {}
    end

    def register(event, obj)
      event = event.to_sym
      @events[event] ||= []
      @events[event] << obj unless @events[event].include?(obj)
    end

    def unregister(event, obj)
      event = event.to_sym
      @events[event] ||= []
      @events[event].delete(obj)
    end

    def trigger(event, *args)
      event = event.to_sym
      @events[event] && @events[event].each do |reg|
        if reg.respond_to?(:call)
          reg.call(*args)
        else
          reg.public_send("on_#{event}", *args)
        end
      end
    end
  end
end
