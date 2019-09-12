module Opstat
module Plugins
class Nagios < Task

  def initialize (name, queue, config)
    merged_config = default_config.merge(config)
    super(name, queue, merged_config)
    oplogger.debug "Plugin config #{merged_config}"
    @nagios_stats_cmd = merged_config['nagios_stats_cmd']
  end

  def parse
    report = []
    xmlIO = IO.popen(@nagios_stats_cmd)
    report  = xmlIO.readlines
    xmlIO.close
    return report
  end

  def default_config
    { 
      'interval' => 600,
      'nagios_stats_cmd' => "/usr/sbin/nagiostats",
    }
  end


end
end
end

