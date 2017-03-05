require "singleton"
require "gosu"
require_relative "window"
require_relative "system/media_manager"
require_relative "system/event_manager"
require_relative "system/object_manager"
require_relative "system/input"
require_relative "ui/ui_manager"
require_relative "objects/zorder"
require_relative "pegs/board_config"
require_relative "pegs/board"
require_relative "pegs/object_board"

module Game
  class Game
    include Singleton

    attr_accessor :show_fps, :debug, :show_objects

    attr_reader :events, :objects, :ui

    def initialize
      @show_fps = true
      @debug = true
      @last_time = 0
      @frames = 0
      @frame_time = 0.0
      @fps = 0

      @window = Window.instance
      @window.caption = "PEGS - JUMP FOR JOY"
      @media = MediaManager.instance
      @events = EventManager.new
      @objects = ObjectManager.new
      @ui = Ui::UiManager.new
      @font = @media.font(:default)

      Input.instance.register(:kb_escape, self)
      events.register(:board_configured, self)

      @objects << BoardConfig.new
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
      # managers' #draw should take window as an arg
      objects.draw
      @ui.draw
      @font.draw("FPS: #{@fps}", 10, @window.height - 16, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
      @font.draw("Objects: #{@objects.objects.length}", 100, @window.height - 16, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_objects
      @font.draw("UI Objects: #{@ui.total_objects}", 220, @window.height - 16, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_objects
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

    def on_board_configured(rows, cols)
      ui << Board.new(rows, cols)
    end

  end
end
