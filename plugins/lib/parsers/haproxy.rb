require 'csv'
require 'yaml'
module Opstat
module Parsers
  class Haproxy
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []
      white_headers = [ :svname, :qcur, :qmax, :scur, :smax, :slim, :stot, :bin, :bout, :hrsp_1xx, :hrsp_2xx, :hrsp_3xx, :hrsp_4xx, :hrsp_5xx, :hrsp_other, :req_tot, :conn_tot]
      parsed_data = CSV.parse(data.join, { headers: true, header_converters: :symbol, converters: :all})#.map{|row| Hash[row.headers[0..-1].zip(row.fields[0..-1])]}.group_by{|row| row[:_pxname]}
      parsed_data.each do |row|
        report = row.to_hash
        report["OPSTAT_TAG_svname"] = report.delete(:svname)
        report["OPSTAT_TAG_pxname"] = report.delete(:pxname)
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

