require "gosu"
require_relative "event_manager"

module System
  class Input < EventManager

    attr_reader :mouse_x, :mouse_y

    def initialize(window)
      super()
      @window = window
      @mouse_x = 0.0
      @mouse_y = 0.0
      @last_mouse_x = 0.0
      @last_mouse_y = 0.0
      @pressed = {}
    end

    def update(delta)
      @last_mouse_x = mouse_x
      @last_mouse_y = mouse_y
      @mouse_x = @window.mouse_x
      @mouse_y = @window.mouse_y

      dx = mouse_x - @last_mouse_x
      dy = mouse_y - @last_mouse_y

      if (dx != 0.0 || dy != 0.0) && mouse_on_screen?
        trigger(:mouse_move, mouse_x, mouse_y, dx, dy)
      end
    end

    def key_down?(id)
      !!@pressed[id]
    end

    def mouse_on_screen?
      mouse_x >= 0.0 && mouse_x <= @window.width && mouse_y >= 0.0 && mouse_y <= @window.height
    end

    def button(id, down)
      case id
      when Gosu::MsLeft
        handle_key(:mouse_left, down, mouse_x, mouse_y)
      when Gosu::MsRight
        handle_key(:mouse_right, down, mouse_x, mouse_y)
      when Gosu::MsMiddle
        handle_key(:mouse_middle, down, mouse_x, mouse_y)
      when Gosu::MsWheelDown
        handle_key(:mouse_wheel_down, down)
      when Gosu::MsWheelUp
        handle_key(:mouse_wheel_up, down)
      when Gosu::KbUp
        handle_key(:kb_up, down)
      when Gosu::KbDown
        handle_key(:kb_down, down)
      when Gosu::KbLeft
        handle_key(:kb_left, down)
      when Gosu::KbRight
        handle_key(:kb_right, down)
      when Gosu::KbEnter
        handle_key(:kb_enter, down)
      when Gosu::KbReturn
        handle_key(:kb_return, down)
      when Gosu::KbEscape
        handle_key(:kb_escape, down)
      when Gosu::KbSpace
        handle_key(:kb_space, down)
      else
        if (char = @window.button_id_to_char(id)) && char.strip.length > 0
          handle_key("kb_#{char}".to_sym, down)
        end
      end
    end

    private

    def handle_key(id, down, *args)
      @pressed[id] = down
      trigger(id, down, *args)
    end

  end
end
