require 'csv'
require 'yaml'
module Opstat
module Parsers
  class Haproxy
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []
      white_headers = [ :svname, :qcur, :qmax, :scur, :smax, :slim, :stot, :bin, :bout, :hrsp_1xx, :hrsp_2xx, :hrsp_3xx, :hrsp_4xx, :hrsp_5xx, :hrsp_other, :req_tot, :conn_tot]
      parsed_data = CSV.parse(data.join, { headers: true, header_converters: :symbol, converters: :all})
      parsed_data.each do |row|
        row_data = row.to_hash
        report = {:time => time, :tags => {'OPSTAT_TAG_svname' => row_data.delete(:svname), 'OPSTAT_TAG_pxname' => row_data.delete(:pxname)}}
        row_data.each_pair do |key,value|
          row_data.delete(key) if value.nil?
        end
        report[:values] = row_data
        reports << report
      end
      return reports
    end
  end
end
end 

