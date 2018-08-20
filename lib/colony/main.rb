require "gosu"

require_relative "../window"
require_relative "../system/media_manager"
require_relative "../system/event_manager"
require_relative "../system/object_repository"
require_relative "../system/object_factory"
require_relative "../system/input"
require_relative "../system/renderer_factory"
require_relative "../system/fill_renderer"
require_relative "../system/font_renderer"
require_relative "../system/outline_renderer"
require_relative "../system/texture_renderer"
require_relative "../ui/ui_manager"
require_relative "../objects/zorder"

require_relative 'ant_factory'
require_relative 'ant_state_factory'
require_relative 'block_factory'
require_relative 'jobs/job_factory'
require_relative 'level'
require_relative 'sound_effects_manager'
require_relative 'use_cases'
require_relative 'work_manager'
require_relative 'objects/ant'
require_relative 'objects/block'
require_relative 'ui/block_selector'
require_relative 'ui/work_tracker'
require_relative 'ui/work_count_tracker'
require_relative 'ui/ants_count_tracker'
require_relative 'ui/dug_count_tracker'

class Game

  attr_accessor :show_fps, :debug, :show_objects

  def initialize
    srand
    @show_fps = false
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
    @font = @media.font(:default)

    outline = System::OutlineRenderer.new(@window)
    fill = System::FillRenderer.new(@window)
    text = System::FontRenderer.new(@font)
    tex_renderer = System::TextureRenderer.new(@window)

    @render_fac = System::RendererFactory.new
    @render_fac.register(Colony::Ant, tex_renderer)
    @render_fac.register(Colony::Block, tex_renderer)
    @render_fac.register(Colony::Ui::BlockSelector, outline)
    @render_fac.register(Colony::Ui::WorkTracker, fill)
    @render_fac.register(Colony::Ui::WorkCountTracker, text)
    @render_fac.register(Colony::Ui::AntsCountTracker, text)
    @render_fac.register(Colony::Ui::DugCountTracker, text)

    @input.register(:kb_escape, self)
    @input.register(:kb_space, self)
    @input.register(:kb_m, self)
  end

  def init
    @block_repo = System::ObjectRepository.new
    @ant_repo = System::ObjectRepository.new

    block_fac = Colony::BlockFactory.new(@media)
    level = Colony::Level.new(block_fac, @block_repo, @window)
    work_manager = Colony::WorkManager.new(level, @events)
    ant_state_factory = Colony::AntStateFactory.new(level, work_manager, @events)
    ant_fac = Colony::AntFactory.new(ant_state_factory, @media, @events)
    job_factory = Colony::JobFactory.new(@events)

    @ui = Ui::UiManager.new(@input)
    @ui << Colony::Ui::BlockSelector.new(level, work_manager, job_factory, @input)
    @ui << Colony::Ui::WorkTracker.new(work_manager, level)
    @ui << Colony::Ui::WorkCountTracker.new(work_manager)
    @ui << Colony::Ui::AntsCountTracker.new(@events)
    @ui << Colony::Ui::DugCountTracker.new(@events)

    Colony::UseCases.init(@events, @input, level, work_manager, job_factory)
    Colony::SoundEffectsManager.init(@events, @media)

    17.times do
      a = ant_fac.build
      a.x = rand(level.left..level.right)
      block = level.get_block_at(a.x, level.top + 1)
      a.y = block.top - 1
      @ant_repo.add(a)
    end

    @song = @media.music(:giant)
    @song.play(true)
  end

  def update
    time = Gosu::milliseconds
    delta = (time - @last_time) * 0.001
    @last_time = time

    calc_fps(delta) if @show_fps

    @input.update(delta)
    @block_repo.all.each { |obj| obj.update(delta) }
    @ant_repo.all.each { |obj| obj.update(@paused ? 0.0 : delta) }

    time2 = Gosu::milliseconds
    @oup = (time2 - time) * 0.001
    @ui.all.each { |obj| obj.update(delta) }
    @uiup = (Gosu::milliseconds - time2) * 0.001
  end

  def draw
    time = Gosu::milliseconds
    @block_repo.all.each { |b| b.draw(@render_fac) }
    @ant_repo.all.each { |a| a.draw(@render_fac) }

    time2 = Gosu::milliseconds
    @od = (time2 - time) * 0.001
    @ui.all.each { |u| u.draw(@render_fac) }
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

  def on_kb_space(down)
    @paused = !@paused if down
  end

  def on_kb_m(down)
    return unless down
    if @song.playing?
      @song.pause
    else
      @song.play
    end
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
