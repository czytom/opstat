#!/usr/bin/env ruby
require 'rubygems'
require 'yaml'
require './plugin.rb'
require './db/fsaver.rb'
require 'eventmachine'
require 'amqp'
require 'json'
require './common.rb'
require './parser.rb'

include Opstat::Parsers

puts 'START'

@report_data = Hash.new
@quant = 60

@chart_data = []
@instances = Hash.new

#TODO order by timestamp
Ifirma.find(:all,:order => 'timestamp', :conditions => ['timestamp >= ? ',Time.now - 144000]).each do |data|
  @instances[data[:instance]] ||= true
  rounded_timestamp = data[:timestamp].to_i - ( data[:timestamp].to_i % @quant )
  @report_data[rounded_timestamp] ||= Hash.new

  @report_data[rounded_timestamp][data[:instance]] ||= data[:sessions] 
end


@report_data.each do |timestamp, sessions_hash|
  sessions_hash
  temp = sessions_hash
  temp["year"] = timestamp.to_i * 1000
  @chart_data << temp
end

require 'erb'
template_file = File.open("/var/www/localhost/htdocs/amcharts/samples/ifirma.html", 'r').read
erb = ERB.new(template_file)
puts erb.result(binding)

