require 'pub_sub'
require 'json'

require_relative 'events'

module Colony
  class Network

    CHANNEL = :colony

    def self.init(eventer)
      @pub_sub = PubSub.new

      [Events::Ants::SPAWNED].each do |e|
        eventer.register(e, self)
      end
    end

    def self.on_ant_spawned(ant)
      ant_data = AntSerializer.new(ant).serialize
      publish(ant_data.merge(event: :ant_spawned))
    end

    private

    def self.publish(data)
      @pub_sub.publish(CHANNEL, data.to_json)
    end

    class AntSerializer
      def initialize(ant)
        @ant = ant
      end

      def serialize
        {
          id: @ant.id,
          speed: @ant.speed,
          damage: @ant.damage,
          attack_speed: @ant.attack_time
          # health/max_health
        }
      end
    end

  end
end
