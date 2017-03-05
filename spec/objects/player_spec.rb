require "spec_helper"
require_relative "../../lib/objects/player.rb"

describe Game::Player do
  stub_window
  stub_input
  stub_media_manager
  let(:texture) { double :Texture, width: 100, height: 100 }

  before do
    allow(media_manager).to receive(:image).with(:player).and_return(texture)
  end

  it "is a singleton" do
    expect(subject).to_not be_nil
    expect(subject.x).to eq window.width * 0.5
    expect(subject.y).to eq window.height * 0.5
    expect(subject.texture).to eq texture
  end

  describe "when being updated" do
    it "looks at the mouse pointer" do
      subject.update(0)

      expect(subject.angle).to eq Gosu::angle(subject.x, subject.y, input.mouse_x, input.mouse_y)
    end

    it "shoots a bullet when space is pressed" do
      subject.update(1.0)
    end
  end
end
