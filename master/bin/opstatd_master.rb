require 'rubygems'
require 'daemons'
require 'opstat-master'
 
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
