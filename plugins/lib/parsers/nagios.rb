module Opstat
module Parsers
  class Nagios
    include Opstat::Logging

    def parse_data(data:, time:)
      report = {}
      begin
        data.compact.each do |elem|
          v = elem.strip.split(':')
	  next if  v.length == 0
	  next if v.count != 2
	  key = v[0].strip
	  val = v[1].strip
	  report[key] = val
        end
      rescue
      #TODO add errors to gui - bad data
        return
      end
      report["Hosts Up"], report["Hosts Down"], report["Hosts Unreachable"] = report["Hosts Up/Down/Unreach"].split('/')
      report["Services Ok"], report["Services Warning"], report["Services Unknown"], report["Services Critical"] = report["Services Ok/Warn/Unk/Crit"].split('/')
      return [{:time => time, :values => {
            :services_total => report["Total Services"].to_i,
            :hosts_total => report["Total Hosts"].to_i,
            :services_checked => report["Services Checked"].to_i,
            :hosts_checked => report["Hosts Checked"].to_i,
            :services_ok => report["Services Ok"].to_i,
            :services_warning => report["Services Warning"].to_i,
            :services_critical => report["Services Critical"].to_i,
            :services_unknown => report["Services Unknown"].to_i,
            :hosts_up => report["Hosts Up"].to_i,
            :hosts_down => report["Hosts Down"].to_i,
	    :hosts_unreachable => report ["Hosts Unreachable"].to_i
      }}]
    end
  end
end
end
