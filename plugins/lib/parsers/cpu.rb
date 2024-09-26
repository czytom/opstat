module Opstat
module Parsers
  class Cpu < Parser
    include Opstat::Logging

    def parse_specific_data(data:, time:, host:, plugin_type:)
      reports = []
      system_report = {:values => {}, :time => time , :plugin_type => 'system'}
      data.each do |line|
        case line
          when /(?<OPSTAT_TAG_cpu_id>cpu\S*)\s+(?<user>\d+)\s+(?<nice>\d+)\s+(?<system>\d+)\s+(?<idle>\d+)\s+(?<iowait>\d+)\s+(?<irq>\d+)\s+(?<softirq>\d+).*/
            reports << {:values => {
	      :OPSTAT_TAG_cpu_id => $~[:OPSTAT_TAG_cpu_id],
              :user => $~[:user].to_i,
              :nice => $~[:nice].to_i,
              :system => $~[:system].to_i,
              :idle => $~[:idle].to_i,
              :iowait => $~[:iowait].to_i,
              :irq => $~[:irq].to_i,
              :softirq => $~[:softirq].to_i
	    },
            :time => time
            }
          when /procs_blocked\s+(?<processes_blocked>\d+)/
            system_report[:values][:processes_blocked] = $~[:processes_blocked].to_i
          when /procs_running\s+(?<processes_running>\d+)/
            system_report[:values][:processes_running] = $~[:processes_running].to_i
          when /processes\s+(?<processes>\d+)/
            system_report[:values][:processes] = $~[:processes].to_i
          when /ctxt\s+(?<context_switches>\d+)/
            system_report[:values][:context_switches] = $~[:context_switches].to_i
	end
      end
      reports << system_report
      return reports
    end
  end
end
end
