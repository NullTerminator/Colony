def stub_window
  let!(:window) { double :Window, width: 800, height: 600 }

  before do
    allow(Wankel::Window).to receive(:instance).and_return(window)
  end
end

def stub_input
  let!(:input) { double(:Input, mouse_x: 200, mouse_y: 200, key_down?: false).as_null_object }

  before do
    allow(Wankel::Input).to receive(:instance).and_return(input)
  end
end

def stub_media_manager
  let!(:media_manager) { double :MediaManager }

  before do
    allow(Wankel::MediaManager).to receive(:instance).and_return(media_manager)
  end
end
