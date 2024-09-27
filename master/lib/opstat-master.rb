
require 'opstat-master/master.rb'

begin
  require 'rubygems'
rescue LoadError
end
require 'yaml'
require 'log4r'
require 'opstat-plugins'
require 'eventmachine'
require 'amqp'
require 'json'
require 'singleton'
require 'influxdb'

require 'activemodel-serializers-xml'
require 'opstat-master/config.rb'
require 'opstat-master/common.rb'
require 'opstat-master/db/influx.rb'
require 'opstat-master/logging.rb'
require 'opstat-master/parsers.rb'
#require 'opstat-master/exceptions_notifications.rb'

require 'opstat-master/master.rb'
options = {}
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: command [options]"

  options[:verbose] = false
    opts.on( '-v', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end

  #TODO required options
  opts.on( '-c', '--config-file String', :required,  "Config file path" ) do|l|
    options[:config_file] = l
  end
  options[:config_file] ||= '/etc/opstat/opstat.yml'

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!

Opstat::Config.instance.init_config(options)
 
