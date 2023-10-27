require 'time'

module Opstat
module Parsers
  class FreeswitchUnansweredCalls
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []  
      parsed_data = CSV.parse(data, { headers: true, header_converters: :symbol, converters: :all})
      parsed_data.each do |row|
        report = {:time => row[:time], :tags => {:OPSTAT_TAG_destination_number => row[:destination_number]}, :values => {
          :caller_id_number => row[:caller_id_number], :duration => row[:duration], :billsec => row[:billsec], :end_stamp => row[:end_stamp].to_time.to_i
        }}
        reports << report
      end
      return reports
    end
  end
end
end 
