require "gosu"

require_relative "../window"
require_relative "../system/media_manager"
require_relative "../system/event_manager"
require_relative "../system/object_repository"
require_relative "../system/object_factory"
require_relative "../system/caching_factory"
require_relative "../system/input"
require_relative "../system/fill_renderer"
require_relative "../system/outline_renderer"
require_relative "../ui/ui_manager"
require_relative "../objects/zorder"

require_relative 'level'
require_relative 'use_cases'
require_relative 'work_manager'
require_relative 'objects/ant'
require_relative 'objects/block'
require_relative 'ui/block_selector'
require_relative 'ui/work_tracker'

class Game

  attr_accessor :show_fps, :debug, :show_objects

  attr_reader :events, :ui

  def initialize
    @show_fps = true
    @debug = false
    @last_time = Gosu::milliseconds
    @frames = 0
    @frame_time = 0.0
    @fps = 0

    @window = System::Window.new(self)
    @window.caption = "THE COLONY"
    @media = System::MediaManager.new
    @events = System::EventManager.new
    @input = System::Input.new(@window)
    @ui = Ui::UiManager.new(@input)
    @font = @media.font(:default)

    fill = System::FillRenderer.new(@window)
    outline = System::OutlineRenderer.new(@window)
    @block_repo = System::ObjectRepository.new
    @ant_repo = System::ObjectRepository.new

    Colony::Ui::BlockSelector.renderer = outline
    Colony::Ui::WorkTracker.renderer = outline
    @block_fac = System::ObjectFactory.new(Colony::Block, fill)
    @ant_fac = System::CachingFactory.new(Colony::Ant, fill)

    @input.register(:kb_escape, self)
  end

  def init
    level = Colony::Level.new(@block_fac, @block_repo, @window)
    work_manager = Colony::WorkManager.new(@events)
    ui << Colony::Ui::BlockSelector.new(level, @events)
    ui << Colony::Ui::WorkTracker.new(work_manager)
    Colony::UseCases.init(events, work_manager)

    10.times do
      a = @ant_fac.build
      a.y = 55
      a.x = rand(level.width) + level.left
      @ant_repo.add(a)
    end
  end

  def update
    time = Gosu::milliseconds
    delta = (time - @last_time) * 0.001
    @last_time = time

    calc_fps(delta) if @show_fps

    @input.update(delta)
    @ant_repo.all.each { |obj| obj.update(delta) }
    @block_repo.all.each { |obj| obj.update(delta) }

    time2 = Gosu::milliseconds
    @oup = (time2 - time) * 0.001
    @ui.all.each { |obj| obj.update(delta) }
    @uiup = (Gosu::milliseconds - time2) * 0.001
  end

  def draw
    time = Gosu::milliseconds
    @ant_repo.all.each(&:draw)
    @block_repo.all.each(&:draw)

    time2 = Gosu::milliseconds
    @od = (time2 - time) * 0.001
    @ui.all.each(&:draw)
    @uid = (Gosu::milliseconds - time2) * 0.001

    @font.draw("FPS: #{@fps}", 10, @window.height - 20, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw("Objects update: #{@oup}", 10, @window.height - 100, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw("Ui update: #{@uiup}", 10, @window.height - 80, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw("Objects draw: #{@od}", 10, @window.height - 60, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw("Ui draw: #{@uid}", 10, @window.height - 40, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw("Objects: #{@ant_repo.all.length + @block_repo.all.length}", 100, @window.height - 16, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_objects
  end

  def show
    @window.show
  end

  def button(id, down)
    @input.button(id, down)
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
