begin
  require 'pub_sub'
rescue LoadError
end

require 'json'

require_relative 'events'

module Colony
  class Network

    CHANNEL = :colony

    def self.init(eventer, ant_repo)
      @pub_sub = PubSub.new if defined?(PubSub)
      @ant_repo = ant_repo

      [Events::Ants::SPAWNED].each do |e|
        eventer.register(e, self)
      end

      @pub_sub.subscribe(CHANNEL) do |data|
        d = JSON.parse(data)
        event = d['event'].to_sym
        case event
        when :sync
          send_sync_data
        end
      end
    end

    def self.on_ant_spawned(ant)
      ant_data = AntSerializer.new(ant).serialize
      publish(ant_data.merge(event: Events::Network::ANT))
    end

    private

    def self.send_sync_data
      @ant_repo.all.each do |ant|
        ant_data = AntSerializer.new(ant).serialize
        publish(ant_data.merge(event: Events::Network::ANT))
      end
    end

    def self.publish(data)
      @pub_sub&.publish(CHANNEL, data.to_json)
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
