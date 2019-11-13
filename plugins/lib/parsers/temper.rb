module Opstat
module Parsers
  require 'json'
  class Temper
    include Opstat::Logging

    def parse_data(data:, time:)
      temperature = data.split(',')[1].to_f
      temperature = JSON::parse(data)["temperature_celsius"]
      return [{
	    :temperature => temperature
      }]
    end
  end
end
end
