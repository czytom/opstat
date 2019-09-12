module Opstat
module Plugins
class Webobjects < Task

  def initialize (name, queue, config)
    merged_config = default_config.merge(config)
    super(name, queue, merged_config)
    oplogger.debug "Plugin config #{merged_config}"
    @wo_monitor_password = merged_config['wo_monitor_password']
    @wo_monitor_host = merged_config['wo_monitor_host']
    @wo_monitor_url = merged_config['wo_monitor_url']
    @wo_monitor_port = merged_config['wo_monitor_port']
    self
  end

  def parse
    report = []
    curl_cmd ||= '/usr/bin/curl \'http://' +  @wo_monitor_host + ':' + @wo_monitor_port + @wo_monitor_url + '?pw=' + @wo_monitor_password + '&type=all\'' + ' 2>/dev/null'
    output_io = IO.popen(curl_cmd)
    report  = output_io.readlines.join
    oplogger.debug report
    output_io.close
    return report
  end
  
  def default_config
    {
      'interval' => 60,
      'wo_monitor_password' => "password",
      'wo_monitor_host' => "127.0.0.1",
      'wo_monitor_port' => "666",
      'wo_monitor_url' => "/cgi-bin/WebObjects/JavaMonitor.woa/admin/info",
    }
  end

  def check_prerequisities
    #NEEDED - curl
  end

end
end
end
