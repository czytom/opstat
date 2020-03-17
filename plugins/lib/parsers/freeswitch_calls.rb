require 'time'

module Opstat
module Parsers
  class FreeswitchCalls
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []  
      parsed_data = CSV.parse(data, { headers: true, header_converters: :symbol, converters: :all})
#      time:Tue, 17 Mar 2020 09:05:33 +0000 answer_stamp:Tue, 17 Mar 2020 09:05:44 +0000 end_stamp:Tue, 17 Mar 2020 09:13:12 +0000 duration:459 billsec:448 operator:"Grzegorzewska Anna" destination_number:601323426
      parsed_data.each do |row|
        report = {:time => row[:time], :tags => {:operator => row[:operator], :destination_number => row[:destination_number]}, :values => {
          :duration => row[:duration], :billsec => row[:billsec], :answer_stamp => row[:answer_stamp].to_i, :end_stamp => row[:end_stamp].to_i
        }}
        reports << report
      end
      return reports
    end
  end
end
end 
