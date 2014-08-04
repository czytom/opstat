module Opstat
module Parsers
  class OracleSessions
    include Opstat::Logging

  #TODO - somehow check plugins version
    def save_data(data)
      report = nil
      data.split("\n")[3..-1].each do |line|
	  tablespace = line.split(/\s+/).delete_if{|t| t.empty?}
          report = {
	    :host_id => host_id,
            :plugin_id => plugin_id,
            :timestamp => time,
            :used => tablespace[0].to_i,
            :free => tablespace[1].to_i
	  }
      end
      oplogger.info "Saving parsed data from #{host_id} on #{time}"
      return report
    end
  end
end
end
