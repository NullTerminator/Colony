require "singleton"
require "gosu"

require_relative "../window"
require_relative "../system/media_manager"
require_relative "../system/event_manager"
require_relative "../system/object_manager"
require_relative "../system/input"
require_relative "../ui/ui_manager"
require_relative "../objects/zorder"

require_relative 'use_cases'
require_relative 'level'
require_relative 'ui/block_selector'
require_relative 'ui/work_tracker'

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

    @window = System::Window.instance
    @window.caption = "THE COLONY"
    @media = System::MediaManager.instance
    @events = System::EventManager.new
    @objects = System::ObjectManager.new
    @ui = Ui::UiManager.new
    @font = @media.font(:default)

    System::Input.instance.register(:kb_escape, self)
  end

  def init
    Colony::UseCases.init
    Colony::Level.instance
    ui << Colony::Ui::BlockSelector.new
    ui << Colony::Ui::WorkTracker.new
  end

  def update
    time = Gosu::milliseconds
    delta = (time - @last_time) * 0.001
    @last_time = time

    calc_fps(delta) if @show_fps

    System::Input.instance.update(delta)
    objects.update(delta)
    @ui.update(delta)
  end

  def draw
    objects.draw
    @ui.draw
    @font.draw("FPS: #{@fps}", 10, @window.height - 16, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw("Objects: #{@objects.total_objects}", 100, @window.height - 16, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_objects
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
