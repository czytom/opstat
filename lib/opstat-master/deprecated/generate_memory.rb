#!/usr/bin/env ruby
#require 'rubygems'
require 'yaml'
#require '../plugin.rb'
require '../db/fsaver.rb'
require 'json'
#require '../common.rb'
require '../parser.rb'

include Opstat::Parsers


@report_data = Hash.new
@quant = 60

@chart_data = []
@memory_areas = { "Used" => true, "Buffers" => true, "Cached" => true, "SwapUsed" => true }

ip_address = '192.168.200.10'

#TODO order by timestamp
Memory.find(:all,:order => 'timestamp', :conditions => ['timestamp >= ? and ip_address = ?',Time.now - 216000, ip_address]).each do |data|
  @chart_data << {
  "year" => data[:timestamp].to_i * 1000,
  "Used" => data[:used],
  "Cached" => data[:cached],
  "Buffers" => data[:buffers],
  "SwapUsed" => data[:swap_used]
  }
end

require 'erb'
template_file = File.open("/var/www/localhost/htdocs/amcharts/samples/memory.erb", 'r').read
erb = ERB.new(template_file)
puts erb.result(binding)

