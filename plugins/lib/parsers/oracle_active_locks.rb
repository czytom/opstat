module Opstat
module Parsers
  class OracleActiveLocks
    include Opstat::Logging

  #TODO - somehow check plugins version
    def parse_data(data:, time:)
      reports = []
      data.split("\n")[3..-3].each do |line|
	  user_locks = line.split("\t").reject{|l| l.empty?}
	  next unless user_locks.is_a?(Array)
          reports << {:time => time, :tags => {
            :OPSTAT_TAG_user => user_locks.first,
            },
            :values => {
              :active_locks => user_locks.last.to_i
            }
	  }
      end
      return reports
    end
  end
end
end
