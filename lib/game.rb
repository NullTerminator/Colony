require "singleton"

require "gosu"

require_relative "window"
require_relative "system/media_manager"
require_relative "system/event_manager"
require_relative "system/object_manager"
require_relative "system/input"
require_relative "ui/ui_manager"

module Game
  class Game
    include Singleton

    attr_accessor :show_fps, :debug, :show_objects

    attr_reader :events, :objects, :enemies

    def initialize
      @show_fps = true
      @debug = true
      @last_time = 0
      @frames = 0
      @frame_time = 0.0
      @fps = 0

      @window = Window.instance
      @media = MediaManager.instance
      @events = EventManager.new
      @objects = ObjectManager.new
      @ui = Ui::UiManager.new

      @font = @media.font(:default)

      #@enemies = ObjectManager.new
      #btn = Ui::Button.new(0, 0, @media.image(:load_btn_up), @media.image(:load_btn_down))
      #@ui << btn
      #btn.scale_x = 3
      #btn.scale_y = 3
      #btn.x = @window.width - btn.width - 10
      #btn.y = @window.height - btn.height - 10
      #btn.click = lambda { @media.sound(:beep).play }

      #def star
        #@media.animation(:star)
      #end
      #objects.add(RenderObject.new(10, 10, 1, star, 1, 1, Color.rgba(255, 0, 0)))
      #objects.add(RenderObject.new(100, 10, 1, star, 1, 1, Color.rgba(0, 255, 0)))
      #objects.add(RenderObject.new(10, 100, 1, star, 2, 2, Color.rgba(0, 0, 255)))
      #objects.add(RenderObject.new(100, 100, 1, star, 1, 1, Color.rgba(255, 255, 255)))

      #objects << RenderObject.new(150, 100, 1, star, 2, 2, Color.rgba(255, 0, 0, 90))

      #40.times do
        #square = Seeker.new
        #square.x = Float(rand(@window.width))
        #square.y = Float(rand(@window.height))
        #objects << square
        #enemies << square
      #end

      #objects << Player.instance

      #@ui << Ui::FileMenu.new(300, 50)

      Input.instance.register(:kb_escape, self)
    end

    def update
      time = Gosu::milliseconds
      delta = (time - @last_time) * 0.001
      @last_time = time

      calc_fps(delta) if @show_fps

      Input.instance.update(delta)
      objects.update(delta)
      @ui.update(delta)
    end

    def draw
      objects.draw
      @ui.draw
      @font.draw("FPS: #{@fps}", 10, @window.height - 16, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
      @font.draw("Objects: #{@objects.objects.length}", 100, @window.height - 16, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_objects
    end

    def on_kb_escape(down)
      @window.close if down
    end

    private

    def calc_fps(delta)
      @frames += 1
      @frame_time += delta
      if @frame_time >= 1.0
        @fps = @frames
        @frames = 0
        @frame_time -= 1.0
      end
    end
  end
end
