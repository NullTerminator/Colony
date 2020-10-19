require 'json'

module Colony
  class OverseerNetwork

    CHANNEL = :colony

    def self.init(ant_repo)
      pub_sub = PubSub.new

      pub_sub.subscribe(CHANNEL) do |data|
        d = JSON.parse(data)
        event = d['event'].to_sym
        case event
        when :ant_spawned
          ant_repo.add(d)
        end
      end
    end

  end
end
