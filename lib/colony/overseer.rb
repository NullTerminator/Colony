require_relative "ui/overseer_cursor"
require_relative "ui/overseer_ant_cards"
require_relative 'overseer_network'

class Overseer

  attr_accessor :show_fps, :debug, :show_objects

  def initialize
    srand
    @show_fps = false
    @debug = false
    @last_time = Gosu::milliseconds
    @frames = 0
    @frame_time = 0.0
    @fps = 0

    @window = Wankel::Window.new('OVERSEER', self, needs_cursor: false)
    @media = Wankel::MediaManager.new
    @events = Wankel::EventManager.new
    @input = Wankel::Input.new(@window)
    @font = @media.font(:default)

    outline = Wankel::OutlineRenderer.new(@window)
    fill = Wankel::FillRenderer.new(@window)
    text = Wankel::FontRenderer.new(@font)
    tex_renderer = Wankel::TextureRenderer.new(@window)

    @render_fac = Wankel::RendererFactory.new
    @render_fac.register(Colony::Ui::OverseerCursor, tex_renderer)

    @input.register(:kb_escape, self)
  end

  def init
    @ui = Wankel::Ui::UiManager.new(@input)
    @ui << Colony::Ui::OverseerCursor.new(@input, @media)
    cards = Colony::Ui::OverseerAntCards.new(@input, @media, @window, @font)
    @ui << cards

    Colony::OverseerNetwork.init(cards)
  end

  def update
    time = Gosu::milliseconds
    delta = (time - @last_time) * 0.001
    @last_time = time

    calc_fps(delta) if @show_fps

    @input.update(delta)

    time2 = Gosu::milliseconds
    @oup = (time2 - time) * 0.001
    @ui.all.each { |obj| obj.update(delta) }
    @uiup = (Gosu::milliseconds - time2) * 0.001
  end

  def draw
    time = Gosu::milliseconds

    time2 = Gosu::milliseconds
    @od = (time2 - time) * 0.001
    @ui.all.each { |u| u.draw(@render_fac) }
    @uid = (Gosu::milliseconds - time2) * 0.001

    @font.draw_text('OVERSEER', @window.width * 0.5 - 90, 10, Wankel::ZOrder::UI, 2.0, 2.0, 0xffffff00)

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
