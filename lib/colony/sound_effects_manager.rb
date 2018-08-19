require_relative 'events'

module Colony

  class SoundEffectsManager

    EVENTS = [
      Events::Ants::WALK_START,
      Events::Ants::WALK_END,
      Events::Ants::DIG_START,
      Events::Ants::DIG_END,
      Events::Ants::FILL_START,
      Events::Ants::FILL_END
    ]

    def self.init(eventer, media)
      @media = media
      @sounds = Hash.new { |h, k| h[k] = {} }

      eventer.register(EVENTS, self)
    end

    def self.on_ant_walk_start(ant)
      @sounds[ant][:ant_walk] = @media.sound(:ant_walk).play(0.1, 1, true)
    end

    def self.on_ant_walk_end(ant)
      @sounds[ant].delete(:ant_walk).stop
    end

    def self.on_ant_dig_start(ant)
      @sounds[ant][:ant_dig] = @media.sound(:ant_dig).play(1, 1, true)
    end

    def self.on_ant_dig_end(ant)
      @sounds[ant].delete(:ant_dig).stop
    end

    def self.on_ant_fill_start(ant)
      @sounds[ant][:ant_fill] = @media.sound(:ant_fill).play(1, 1, true)
    end

    def self.on_ant_fill_end(ant)
      @sounds[ant].delete(:ant_fill).stop
    end

  end

end
