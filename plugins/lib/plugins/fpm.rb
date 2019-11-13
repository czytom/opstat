module Opstat
module Plugins
class Fpm < Task
  require 'json'

  def initialize (name, queue, config)
    super(name, queue, config)
    @pools = config['pools']
    self
  end

  def parse
    report = []
    @pools.each_pair do |pool,options|
      oplogger.debug "getting #{pool} statistics"
      env = {"REQUEST_METHOD" => options['request_method'], "SCRIPT_NAME" => options['status_url'], "SCRIPT_FILENAME" => options['status_url'], "QUERY_STRING" => 'json'}
      oplogger.debug "cgi-fcgi environment: #{env.inspect}"
      fpm_io = IO.popen([env, 'cgi-fcgi','-bind','-connect',options['fcgi_socket'] ])
      pool_report  = fpm_io.readlines
      oplogger.debug "#{pool} statistics: #{pool_report}"
      report << pool_report
      fpm_io.close
    end
    return report
  end

end
end
end
