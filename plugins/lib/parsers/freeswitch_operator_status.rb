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
        active_operators = CSV.parse(data['active'], { headers: true, header_converters: :symbol, converters: :all}).map(&:to_h)
        active_operator_numbers = active_operators.map{|v| v[:dest]}
      end
      data['all'].each do |operator|
        active_operator_data = active_operators.find{|o| o[:dest] == operator['number']}
        report = {:time => time, :tags => {
          :operator => operator['name'],
          :callstate => active_operator_data ? active_operator_data[:callstate] : nil,
          :phone => operator['number'],
          :department => operator['department'],
          :created => active_operator_data ? active_operator_data[:created] : nil
        },
        :values => {
          :cid_num => active_operator_data ? active_operator_data[:cid_num].to_s : '',
          :busy => active_operator_numbers.include?(operator['number'])
        }
        }
        reports << report
      end
      return reports
    end
  end
end
end 
