module Opstat
module Parsers
  class Facts
    include Opstat::Logging

    def parse_data(data:, time:)
      [{ :facts => data }]
    end
  end
end
end
