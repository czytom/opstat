#!/usr/bin/ruby19
#
require 'rubygems'
require 'daemons'
require 'optparse'
require 'opstat-client'
 
 
Daemons.run_proc(
  'opstatd_client', # name of daemon
#  :dir_mode => :normal
  :dir => '/var/run', # directory where pid file will be stored
  :backtrace => true,
#  :monitor => true,
  :log_dir => '/var/log',
  :log_output => true
) do
   Opstat::Client.main_loop
end
