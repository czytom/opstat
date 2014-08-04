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

ip_address = '10.5.0.22'
ip_address = '192.168.200.10'
ip_address = '192.168.202.10'
ip_address = '192.168.200.210'
plugin = 'cpu'

@chart_data = []
@prev = nil

@prev = nil
Cpu.find(:all,:order => "timestamp", :conditions => ['timestamp >= ? and ip_address = ?',Time.now - 90000, ip_address]).each do |data|
  if @prev.nil? then
    @prev = data
    next
  end
#  puts "#{data[:system]} #{@prev[:system]} #{data[:system] - @prev[:system]}"
#  puts data[:timestamp].strftime("%Y %m %d %H %M %S")
  #"year" => data[:timestamp].strftime("%a %b %d %Y %H:%M:%S"),
  #30 2013 15:40:33 GMT+0100 (CET)
  @chart_data << {
  "year" => data[:timestamp].to_i * 1000,
  "system" => data[:system] - @prev[:system],
  "nice" => data[:nice] - @prev[:nice],
  "user" => data[:user] - @prev[:user],
  "idle" => data[:idle] - @prev[:idle]
  }

  @prev = data
end

require 'erb'
template_file = File.open("/var/www/localhost/htdocs/amcharts/samples/cpu.erb", 'r').read
erb = ERB.new(template_file)
puts erb.result(binding)

