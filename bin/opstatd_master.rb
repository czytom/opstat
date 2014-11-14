#!/usr/bin/ruby19
#
require 'rubygems'
require 'daemons'
require 'opstat-master'
 
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
 
 Daemons.run_proc(
   'opstatd_master', # name of daemon
 #  :dir_mode => :normal
   :dir => '/var/run', # directory where pid file will be stored
   :backtrace => true,
 #  :monitor => true,
   :log_dir => '/var/log',
   :log_output => true
 ) do
   
   Opstat::Master.main_loop
 end
