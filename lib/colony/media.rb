module Colony

  class Media

    def self.init
      media = Wankel::MediaManager.new('media')
      load_images(media)
      load_sounds(media)
      load_music(media)
      load_fonts(media)
      media
    end

    private

    def self.load_images(m)
      m.load_image(:ant, 'red_ant.png')
      m.load_image(:dirt, 'dirt.png', tileable: true)
      m.load_image(:grass, 'grass.png')
      m.load_image(:cursor_shovel, 'shovel.png')
      m.load_image(:cursor_arrow, 'cursor_arrow.png')
    end

    def self.load_sounds(m)
      m.load_sound(:beep, 'Beep.wav')
      m.load_sound(:ant_walk, 'ant_walk_1.mp3')
      m.load_sound(:ant_dig, 'ant_dig.m4a')
      m.load_sound(:ant_fill, 'ant_fill.mp3')
    end

    def self.load_music(m)
      m.load_music(:background, 'Giant.mp3')
    end

    def self.load_fonts(m)
      m.load_font(:default, Gosu::default_font_name, 18)
      m.load_font(:default_large, Gosu::default_font_name, 35)
    end

  end

end
