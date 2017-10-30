require_relative "../../lib/system/input.rb"

class Foo
end

describe System::Input do
  subject { described_class.new(window) }

  let(:window) { double(mouse_x: 11, mouse_y: 22, width: 100, height: 100) }

  it "defaults mouse positions" do
    expect(subject.mouse_x).to eq 0.0
    expect(subject.mouse_y).to eq 0.0
  end

  describe "update callback" do

    it "saves mouse position from Window" do
      subject.update(0.1)
      expect(subject.mouse_x).to eq 11
      expect(subject.mouse_y).to eq 22
    end

    context "when mouse has moved" do
      let(:foo) { Foo.new }

      before do
        allow(window).to receive(:mouse_x).and_return(11, 20)
        allow(window).to receive(:mouse_y).and_return(22, 30)
      end

      it "triggers mouse_move event" do
        subject.update(1)
        subject.register(:mouse_move, foo)

        expect(foo).to receive(:on_mouse_move).with(20, 30, 9, 8)

        subject.update(1)
      end
    end
  end

  describe "key presses" do
    it "returns false by default" do
      expect(subject.key_down?(:kb_space)).to be false
    end

    context "when a key has been pressed" do
      it "checking that key returns true" do
        subject.button(Gosu::KbSpace, true)
        expect(subject.key_down?(:kb_space)).to be true
      end
    end

    context "when a key is pressed" do
      let(:foo) { Foo.new }

      it "triggers event when a key is pressed" do
        subject.register(:kb_space, foo)
        expect(foo).to receive(:on_kb_space).with(true)

        subject.button(Gosu::KbSpace, true)
      end
    end
  end

end
