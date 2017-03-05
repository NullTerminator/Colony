require_relative "../../lib/objects/render_object.rb"

describe RenderObject do
  subject { described_class.new(10, 20, 1, texture) }
  let(:texture) { double("Texture", width: 15, height: 15) }

  it { is_expected.to be_visible }

  it "sets postition" do
    expect(subject.x).to eq 10
    expect(subject.y).to eq 20
    expect(subject.z).to eq 1
  end

  it "sets texture" do
    expect(subject.texture).to eq texture
  end

  it "defaults angle" do
    expect(subject.angle).to eq 0.0
  end

  it "defaults scales" do
    expect(subject.scale_x).to eq 1.0
    expect(subject.scale_y).to eq 1.0
  end

  it "can look at another object" do
    expect(subject.angle).to eq 0.0
    target = described_class.new(20, 20, 1)
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
    subject { described_class.new(10, 10, 1) }

    before do
      subject.width = 10
      subject.height = 10
    end

    let(:other) { double :RenderObject, left: 20, right: 30, top: 20, bottom: 30 }

    it "returns false" do
      expect(subject.collide?(other)).to be false
    end

    context "when overlapping another object" do
      let(:other) { double :RenderObject, left: 14, right: 25, top: 14, bottom: 25 }

      it "returns true" do
        expect(subject.collide?(other)).to be true
      end
    end
  end

end
