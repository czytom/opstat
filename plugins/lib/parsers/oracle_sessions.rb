module Opstat
module Parsers
  class OracleSessions
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []
      data.split("\n")[3..-1].each do |line|
	  tablespace = line.split(/\s+/).delete_if{|t| t.empty?}
          reports << {
            :used => tablespace[0].to_i,
            :free => tablespace[1].to_i
	  }
      end
      return reports
    end
  end
end
end
