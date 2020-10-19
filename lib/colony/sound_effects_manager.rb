require_relative 'events'

module Colony

  class SoundEffectsManager

    EVENTS = [
      Events::Ants::WALK_START,
      Events::Ants::WALK_END,
      Events::Ants::FILL_START,
      Events::Ants::FILL_END,
      Events::Blocks::ATTACKED
    ]

    def self.init(eventer, media)
      @media = media
      @sounds = Hash.new { |h, k| h[k] = {} }

      eventer.register(EVENTS, self)
    end

    def self.on_ant_walk_start(ant)
      @sounds[ant][:ant_walk] = @media.sound(:ant_walk).play(0.2, 1, true)
    end

    def self.on_ant_walk_end(ant)
      @sounds[ant].delete(:ant_walk).stop
    end

    def self.on_block_attacked(ant, block, damage)
      @media.sound(:ant_dig).play(1, 1, false)
    end

    def self.on_ant_fill_start(ant)
      @sounds[ant][:ant_fill] = @media.sound(:ant_fill).play(1, 1, true)
    end

    def self.on_ant_fill_end(ant)
      @sounds[ant].delete(:ant_fill).stop
    end

  end

end
