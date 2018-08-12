require_relative "zorder"
require_relative "movable"
require_relative "bullet"
require_relative "../window"
require_relative "../system/input"
require_relative "../system/media_manager"

require "singleton"

module Game
  class Player < Movable
    #include Singleton

    def initialize
      super(ZOrder::PLAYER)
      @texture = System::MediaManager.instance.image(:player)
      window = System::Window.instance
      @x = window.width * 0.5
      @y = window.height * 0.5
      @speed = 10.0
      @shot_gap = 0.1
      @shot_time = 0.0
    end

    def update(delta)
      input = System::Input.instance
      @angle = Gosu::angle(x, y, input.mouse_x, input.mouse_y)

      handle_move_input

      super
      #keep_on_screen

      handle_shooting(delta)
    end

    private

    def handle_move_input
      input = System::Input.instance
      if input.key_down? :kb_w
        @vel_y = Gosu::offset_y(0, 1) * speed
      elsif input.key_down? :kb_s
        @vel_y = Gosu::offset_y(180, 1) * speed
      else
        @vel_y = 0.0
      end

      if input.key_down? :kb_a
        @vel_x = Gosu::offset_x(270, 1) * speed
      elsif input.key_down? :kb_d
        @vel_x = Gosu::offset_x(90, 1) * speed
      else
        @vel_x = 0.0
      end
    end

    def handle_shooting(delta)
      @shot_time -= delta

      if @shot_time <= 0.0
        @shot_time = 0.0

        input = System::Input.instance
        if input.key_down?(:kb_space) || input.key_down?(:mouse_left)
          shoot
          @shot_time = @shot_gap
        end
      end
    end

    def shoot
      shot = Bullet.new
      shot.x = x
      shot.y = y
      Game.instance.objects << shot
      shot.shoot(angle)
    end

  end
end
