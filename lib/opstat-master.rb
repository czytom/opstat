require "opstat-master/version"
# Try to load rubygems.  Hey rubygems, I hate you.
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
require 'opstat-master/db/mongo.rb'
require 'opstat-master/logging.rb'
require 'opstat-master/parsers.rb'

require 'opstat-master/master.rb'
# see the bottom of the file for further inclusions

#------------------------------------------------------------
# the top-level module
#
# all this really does is dictate how the whole system behaves, through
# preferences for things like debugging
#
# it's also a place to find top-level commands like 'debug'

