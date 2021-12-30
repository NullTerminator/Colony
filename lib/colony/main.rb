require_relative 'ant_factory'
require_relative 'ant_state_factory'
require_relative 'block_factory'
require_relative 'camera'
require_relative 'jobs/job_factory'
require_relative 'level'
require_relative 'media'
require_relative 'network'
require_relative 'sound_effects_manager'
require_relative 'use_cases'
require_relative 'work_manager'
require_relative 'objects/ant'
require_relative 'objects/block'
require_relative 'ui/block_selector'
require_relative 'ui/bottom_panel'
require_relative 'ui/work_tracker'
require_relative 'ui/work_count_tracker'
require_relative 'ui/ants_count_tracker'
require_relative 'ui/dug_count_tracker'
require_relative 'ui/scrolling_text_manager'
require_relative 'ui/cursor'

class Game

  WIDTH = 1920
  HEIGHT = 1080

  attr_accessor :show_fps, :debug, :show_objects

  def initialize
    srand
    @show_fps = false
    @debug = false
    @last_time = Gosu::milliseconds
    @frames = 0
    @frame_time = 0.0
    @fps = 0

    @window = Wankel::Window.new('THE COLONY', self, width: WIDTH, height: HEIGHT, needs_cursor: false)
    @eventer = Wankel::EventManager.new
    @input = Wankel::Input.new(@window)

    @media = Colony::Media.init
    @font = @media.font(:default)

    @camera = Colony::Camera.new(@input, @eventer, width: WIDTH, height: HEIGHT * 0.8335)

    outline_cam = Wankel::OutlineRenderer.new(@window, @camera)
    fill_cam = Wankel::FillRenderer.new(@window, @camera)
    text_cam = Wankel::FontRenderer.new(@font, @camera)
    tex_renderer_cam = Wankel::TextureRenderer.new(@window, @camera)

    @render_fac = Wankel::RendererFactory.new

    @render_fac.register(Colony::Ant, tex_renderer_cam)
    @render_fac.register(Colony::Block, tex_renderer_cam)
    @render_fac.register(Wankel::Particle, fill_cam)
    @render_fac.register(Colony::Ui::BlockSelector, outline_cam)
    @render_fac.register(Colony::Ui::WorkTracker, fill_cam)
    @render_fac.register(Colony::Ui::ScrollingTextManager, text_cam)

    text = Wankel::FontRenderer.new(@font)
    tex_renderer = Wankel::TextureRenderer.new(@window)
    fill = Wankel::FillRenderer.new(@window)
    @render_fac.register(Colony::Ui::Cursor, tex_renderer)
    @render_fac.register(Colony::Ui::AntsCountTracker, text)
    @render_fac.register(Colony::Ui::WorkCountTracker, text)
    @render_fac.register(Colony::Ui::DugCountTracker, text)
    @render_fac.register(Colony::Ui::BottomPanel, fill)

    @input.register(:kb_escape, self)
    @input.register(:kb_space, self)
    @input.register(:kb_m, self)
  end

  def init
    @camera.x = 0.0
    @camera.y = 0.0
    @block_repo = Wankel::ObjectRepository.new
    @ant_repo = Wankel::ObjectRepository.new
    @particles = Wankel::ParticleSystem.new

    block_factory = Colony::BlockFactory.new(@media)
    level = Colony::Level.new(block_factory, @block_repo, @window, @camera)
    work_manager = Colony::WorkManager.new(level, @eventer)
    ant_state_factory = Colony::AntStateFactory.new(level, work_manager, @eventer)
    ant_fac = Colony::AntFactory.new(ant_state_factory, @media, @eventer)
    job_factory = Colony::JobFactory.new(@eventer)

    @ui = Wankel::Ui::UiManager.new(@input)
    panel = Colony::Ui::BottomPanel.new
    @ui << Colony::Ui::BlockSelector.new(level, work_manager, job_factory, @input, @eventer)
    @ui << Colony::Ui::WorkTracker.new(work_manager, level)
    @ui << panel
    panel << Colony::Ui::WorkCountTracker.new(work_manager)
    panel << Colony::Ui::AntsCountTracker.new(@eventer)
    panel << Colony::Ui::DugCountTracker.new(@eventer)
    scrolling_text_manager = Colony::Ui::ScrollingTextManager.new
    @ui << scrolling_text_manager
    @ui << Colony::Ui::Cursor.new(@input, panel, @media)

    Colony::UseCases.init(@eventer, @input, level, work_manager, job_factory, scrolling_text_manager, @particles, @block_repo)
    Colony::SoundEffectsManager.init(@eventer, @media)
    Colony::Network.init(@eventer, @ant_repo)

    17.times do
      a = ant_fac.build
      a.x = rand(0.0..1400.0)
      block = level.get_block_at(a.x, 11)
      a.y = block.top
      @ant_repo.add(a)
    end

    @song = @media.music(:background)
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
    @particles.update(delta)

    @camera.update(delta)

    time2 = Gosu::milliseconds
    @oup = (time2 - time) * 0.001
    @ui.all.each { |obj| obj.update(delta) }
    @uiup = (Gosu::milliseconds - time2) * 0.001
  end

  def draw
    time = Gosu::milliseconds
    @block_repo.all.each { |b| b.draw(@render_fac) }
    @ant_repo.all.each { |a| a.draw(@render_fac) }
    @particles.draw(@render_fac)

    time2 = Gosu::milliseconds
    @od = (time2 - time) * 0.001
    @ui.all.each { |u| u.draw(@render_fac) }
    @uid = (Gosu::milliseconds - time2) * 0.001

    @font.draw_text("#{@camera.x.to_i} : #{@camera.y.to_i}", 10, 10, Wankel::ZOrder::UI, 1.0, 1.0, 0xffffff00) if @debug
    @font.draw_text("#{@window.mouse_x.to_i} : #{@window.mouse_y.to_i}", 10, 25, Wankel::ZOrder::UI, 1.0, 1.0, 0xffffff00) if @debug

    @font.draw_text("FPS: #{@fps}", 10, @window.height - 20, Wankel::ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Objects update: #{@oup}", 10, @window.height - 100, Wankel::ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Ui update: #{@uiup}", 10, @window.height - 80, Wankel::ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Objects draw: #{@od}", 10, @window.height - 60, Wankel::ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Ui draw: #{@uid}", 10, @window.height - 40, Wankel::ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Objects: #{@ant_repo.all.length + @block_repo.all.length}", 100, @window.height - 16, Wankel::ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_objects
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
