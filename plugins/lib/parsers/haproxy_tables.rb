require 'csv'
require 'yaml'
module Opstat
module Parsers
  class HaproxyTables
    include Opstat::Logging
    REGEX = /# table:\s+(?<OPSTAT_TAG_table>[^,]+), type:\s+[^,]+, size:(?<table_size>\d+), used:(?<table_used>\d+)/

    def parse_data(data:, time:)
      report = []  
      data.each do |line|
        haproxy_table = REGEX.match(line)
        if haproxy_table
          captured_data = haproxy_table.named_captures
	  captured_data['table_size'] = captured_data['table_size'].to_i
	  captured_data['table_used'] = captured_data['table_used'].to_i
          report << {:values => captured_data, :time => time, :tags => {'OPSTAT_TAG_table' => haproxy_table}}
        end
      end
      return report
    end
  end
end
end 

