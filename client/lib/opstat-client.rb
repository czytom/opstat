begin
  require 'rubygems'
rescue LoadError
end
require 'singleton'
require 'opstat-client/common.rb'
require 'opstat-client/version.rb'
require 'opstat-client/logging.rb'
require 'opstat-client/config.rb'
require 'yaml'
require 'opstat-plugins'
require "opstat-client/plugins.rb"
require 'eventmachine'
require 'amqp'
require 'json'

# see the bottom of the file for further inclusions
require 'opstat-client/client.rb'

#------------------------------------------------------------
# the top-level module
#
# all this really does is dictate how the whole system behaves, through
# preferences for things like debugging
#
# it's also a place to find top-level commands like 'debug'

