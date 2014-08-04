#!/usr/bin/env ruby
require 'rubygems'
require 'yaml'
require '../plugin.rb'
require '../db/fsaver.rb'
require 'eventmachine'
require 'amqp'
require 'json'
require '../common.rb'
require '../parser.rb'

include Opstat::Parsers

puts 'START'

ip_address = '10.5.0.22'
plugin = 'cpu'

@chart_data = []
@prev = nil

@report_data = []
#TODO order by timestamp
Bsdnet.find(:all,:order => 'timestamp', :conditions => ['timestamp >= ? and interface = ?',Time.now - 216000, "vlan254"]).each do |data|
  if @prev.nil? then
    @prev = data
    next
  end
  bytes_in_per_sec = (data[:bytes_in_v4] - @prev[:bytes_in_v4])/(data[:timestamp] - @prev[:timestamp])
  bytes_out_per_sec = (data[:bytes_out_v4] - @prev[:bytes_out_v4])/(data[:timestamp] - @prev[:timestamp])
#  puts "bytes in #{bytes_in_per_sec}, bytes out #{bytes_out_per_sec}"
  @chart_data << {
  "year" => data[:timestamp].to_i * 1000,
  "bytes_out" => bytes_out_per_sec,
  "bytes_in" => bytes_in_per_sec,
  }

  @prev = data
end
require 'erb'
template_file = File.open("/var/www/localhost/htdocs/amcharts/samples/bandwidth.html", 'r').read
erb = ERB.new(template_file)
puts erb.result(binding)

