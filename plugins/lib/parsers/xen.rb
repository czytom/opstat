module Opstat
module Parsers
  class Xen
    include Opstat::Logging

    def parse_data(data:, time:)
      return if data.nil?
      domains = []
      
      begin
        data.split("\n")[1..-1].each do |line|
          oplogger.debug "parsing line #{line}"
          domain = {}
          stats = line.split
          domain['domain'] = stats[0]
          domain['cpu'] = stats[3].to_i
          domain['memory'] = stats[4].to_i
          domain['memory_max'] = stats[6].to_i
          domain['nettx'] = stats[10].to_i
          domain['netrx'] = stats[11].to_i
          domain['vbd_oo'] = stats[13].to_i
          domain['vbd_rd'] = stats[14].to_i
          domain['vbd_wr'] = stats[15].to_i
          domain['vbd_rsect'] = stats[16].to_i
          domain['vbd_wsect'] = stats[17].to_i
          domains << domain
        end
      rescue
        return []
      end
      return domains
    end
  end
end
end
