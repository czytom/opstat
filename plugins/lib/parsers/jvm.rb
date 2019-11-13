module Opstat
module Parsers
  class Jvm
    include Opstat::Logging

    def parse_data(data:, time:)
      return [] if data.nil?
      
      begin
      data.split("\n").each do |line|
        oplogger.debug "parsing line #{line}"
      end
      rescue
        return []
      end
      return report
    end
  end
end
end
