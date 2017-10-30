require_relative "../../lib/objects/render_object.rb"

describe RenderObject do
  subject { described_class.new(1) }
  let(:texture) { double("Texture", width: 15, height: 15) }

  before do
    subject.texture = texture
    subject.move_to(10, 20)
  end

  it { is_expected.to be_visible }

  it "sets z" do
    expect(subject.z).to eq 1
  end

  it "defaults angle" do
    expect(subject.angle).to eq 0.0
  end

  it "defaults scales" do
    expect(subject.scale_x).to eq 1.0
    expect(subject.scale_y).to eq 1.0
  end

  it "can look at another object" do
    subject.move_to(10, 20)
    expect(subject.angle).to eq 0.0
    target = described_class.new(1)
    target.move_to(20, 20)

    subject.look_at(target)

    expect(subject.angle).to eq 90
  end

  describe "#right" do
    it "returns the right side of the object" do
      expect(subject.right).to eq 17.5
    end

    context  "when scale is set" do
      before do
        subject.scale_x = 2
      end

      it "returns the right side of the object" do
        expect(subject.right).to eq 25
      end
    end
  end

  describe "#bottom" do
    it "return the bottom of the object" do
      expect(subject.bottom).to eq 27.5
    end

    context  "when scale is set" do
      before do
        subject.scale_y = 2
      end

      it "returns the right side of the object" do
        expect(subject.bottom).to eq 35
      end
    end
  end

  it "can be hidden" do
    subject.hide
    expect(subject).to_not be_visible
  end

  describe "visibility can be toggled" do
    context "when visible" do
      it "hides the object" do
        subject.toggle_visible
        expect(subject).to_not be_visible
      end
    end

    context "when hidden" do
      before do
        subject.visible = false
      end

      it "shows the object" do
        subject.toggle_visible
        expect(subject).to be_visible
      end
    end
  end

  describe "#collide?" do
    subject { described_class.new(1) }
    let(:other) { described_class.new(1) }
    let(:ox) { 15 }
    let(:oy) { 25 }

    before do
      subject.move_to(10, 10)

      other.move_to(ox, oy)
      other.width = 10
      other.height = 10
    end

    it "returns false" do
      expect(subject.collide?(other)).to be false
    end

    context "when overlapping another object" do
      let(:ox) { 14 }
      let(:oy) { 14 }

      it "returns true" do
        expect(subject.collide?(other)).to be true
      end
    end
  end

end
