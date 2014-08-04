module Opstat
module Parsers
  require 'json'
  class Apache2 
    include Opstat::Logging
    
    def parse_data(data)
      return if data.nil?
      report = {
	:vhosts => []
      }
      oplogger.debug data
      json_data = JSON::parse(data)
      vhost_data = []
      json_data.each_pair do |vhost, stats|
        report[:vhosts] << { :vhost_name => vhost, :stats => stats }
      end
      return report
    end
  end
end
end
