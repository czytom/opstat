module Opstat
module Parsers
  class Cpu
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []
      cpu_summary_report = {}
      data.each do |line|
        case line
        when /(?<OPSTAT_TAG_cpu_id>cpu\S*)\s+(?<user>\d+)\s+(?<nice>\d+)\s+(?<system>\d+)\s+(?<idle>\d+)\s+(?<iowait>\d+)\s+(?<irq>\d+)\s+(?<softirq>\d+).*/
          report = {
	      :OPSTAT_TAG_cpu_id => $~[:OPSTAT_TAG_cpu_id],
              :user => $~[:user].to_i,
              :nice => $~[:nice].to_i,
              :system => $~[:system].to_i,
              :idle => $~[:idle].to_i,
              :iowait => $~[:iowait].to_i,
              :irq => $~[:irq].to_i,
              :softirq => $~[:softirq].to_i
	    }
          if $~[:OPSTAT_TAG_cpu_id] == 'cpu'
            cpu_summary_report = report
          else
            reports << report
          end
        when /procs_blocked\s+(?<processes_blocked>\d+)/
          cpu_summary_report[:processes_blocked] = $~[:processes_blocked].to_i
        when /procs_running\s+(?<processes_running>\d+)/
          cpu_summary_report[:processes_running] = $~[:processes_running].to_i
        when /processes\s+(?<processes>\d+)/
          cpu_summary_report[:processes] = $~[:processes].to_i
        when /ctxt\s+(?<context_switches>\d+)/
          cpu_summary_report[:context_switches] = $~[:context_switches].to_i
        end
      end
      reports << cpu_summary_report unless cpu_summary_report.empty?
      return reports
    end
  end
end
end
