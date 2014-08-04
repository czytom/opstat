require 'rubygems'
require 'active_record'
require 'yaml'
require File.expand_path( File.dirname(__FILE__) + '/tableSchema' )
require File.expand_path( File.dirname(__FILE__) + '/config' )

#TODO rewrite initialization
begin
#  init_table_datab unless Datab.table_exists?
rescue Mysql2::Error
#TODO create database by rake task
  puts "probably u dont have >> #{$1} << database, u have to create it, or misspeld name in config file config_opstat.yml"  if $!.message =~ /Unknown database '(.*)'/
rescue
  p $!
end
