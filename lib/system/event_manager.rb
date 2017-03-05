module System
  class EventManager

    def initialize
      @events = {}
    end

    def register(event, obj)
      @events[event] ||= []
      @events[event] << obj unless @events[event].include?(obj)
    end

    def unregister(event, obj)
      @events[event] ||= []
      @events[event].delete(obj)
    end

    def trigger(event, *args)
      if @events[event]
        @events[event].each { |reg| reg.send("on_#{event}", *args) }
      end
    end
  end
end
