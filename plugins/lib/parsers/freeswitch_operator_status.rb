require 'time'

module Opstat
module Parsers
  class FreeswitchOperatorStatus
    include Opstat::Logging
    def parse_data(data:, time:)
      reports = []  
      active_operators = []
      active_operator_numbers = []
      if data['active'].length > 0
        active_operators = CSV.parse(data['active'], { headers: true, header_converters: :symbol, converters: :all}).map{|h| {:fifo_name => h[:fifo_name], :number => h[:originate_string].rpartition('/').last.to_s, :start_time => h[:start_time]}}
        active_operator_numbers = active_operators.map{|v| v[:number]}
      end
      data['all'].each do |operator|
        operator_number = operator['number'].to_s
        active_operator_data = active_operators.find{|o| o[:number] == operator_number}
        report = {:time => time, :tags => {
          :operator => operator['name'],
          :callstate => active_operator_numbers.include?(operator_number) ? 'ACTIVE' : nil,
          :phone => operator_number,
          :department => operator['department'],
          :created => active_operator_data ? Time.at(active_operator_data[:start_time]) : nil
        },
        :values => {
          :busy => active_operator_numbers.include?(operator_number)
        }
        }
        reports << report
      end
      return reports
    end
  end
end
end 
