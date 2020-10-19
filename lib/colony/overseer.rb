#require 'gosu'

require_relative "../window"
require_relative "../system/media_manager"
require_relative "../system/event_manager"
require_relative "../system/input"
require_relative "../system/renderer_factory"
require_relative "../system/fill_renderer"
require_relative "../system/font_renderer"
require_relative "../system/outline_renderer"
require_relative "../system/texture_renderer"
require_relative "../ui/ui_manager"
require_relative "ui/overseer_cursor"
require_relative "ui/overseer_ant_cards"
require_relative 'overseer_network'
require_relative "../objects/zorder"

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

    @window = System::Window.new(self)
    @window.caption = "OVERSEER"
    @media = System::MediaManager.new
    @events = System::EventManager.new
    @input = System::Input.new(@window)
    @font = @media.font(:default)

    outline = System::OutlineRenderer.new(@window)
    fill = System::FillRenderer.new(@window)
    text = System::FontRenderer.new(@font)
    tex_renderer = System::TextureRenderer.new(@window)

    @render_fac = System::RendererFactory.new
    @render_fac.register(Colony::Ui::OverseerCursor, tex_renderer)

    @input.register(:kb_escape, self)
  end

  def init
    @ui = Ui::UiManager.new(@input)
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

    @font.draw_text('OVERSEER', @window.width * 0.5 - 90, 10, ZOrder::UI, 2.0, 2.0, 0xffffff00)

    @font.draw_text("FPS: #{@fps}", 10, @window.height - 20, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Objects update: #{@oup}", 10, @window.height - 100, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Ui update: #{@uiup}", 10, @window.height - 80, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Objects draw: #{@od}", 10, @window.height - 60, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Ui draw: #{@uid}", 10, @window.height - 40, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_fps
    @font.draw_text("Objects: #{@ant_repo.all.length + @block_repo.all.length}", 100, @window.height - 16, ZOrder::UI, 1.0, 1.0, 0xffffff00) if @show_objects
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
