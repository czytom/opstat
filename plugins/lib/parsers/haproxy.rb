require 'csv'
require 'yaml'
module Opstat
module Parsers
  class Haproxy
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []
      parsed_data = CSV.parse(data.join, { headers: true, header_converters: :symbol, converters: :all})
      parsed_data.each do |row|
        report = row.to_hash
        report[:OPSTAT_TAG_svname] = report.delete(:svname)
        report[:OPSTAT_TAG_pxname] = report.delete(:pxname)
        report.each_pair do |key,value|
          report.delete(key) if value.nil?
        end
        reports << report
      end
      return reports
    end
  end
end
end 

