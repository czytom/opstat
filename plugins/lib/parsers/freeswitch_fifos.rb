require 'xmlhasher'
require 'time'

XmlHasher.configure do |config|
  config.snakecase = true
  config.ignore_namespaces = true
  config.string_keys = false
end

module Opstat
module Parsers
  SKIP_FIFO_NAMES = ['manual_calls']
  class FreeswitchFifos
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []  
      XmlHasher.parse(data)[:fifo_report][:fifo].each do |fifo|
        next if SKIP_FIFO_NAMES.include?(fifo[:name])
        report = {}
        report[:OPSTAT_TAG_fifo_name] = fifo[:name]
        report[:waiting_calls] = fifo[:waiting_count].to_i
        report[:outbound_per_cycle] = fifo[:outbound_per_cycle].to_i
        if fifo[:outbound].nil?
          report[:operators] = 0
        else
          if fifo[:outbound][:member].is_a?(String)
            report[:operators] = 1
          else
            report[:operators] = fifo[:outbound][:member].count
          end
        end
        if fifo[:bridges].nil?
          report[:active_calls] = 0
        else
          require 'pp'
          if fifo[:bridges][:bridge].is_a?(Hash)
            report[:active_calls] = 1
          else
            report[:active_calls] = fifo[:bridges][:bridge].count
          end
        end

        if fifo[:callers].nil?
          report[:queue_max_waiting_time] = 0
        else
          if fifo[:callers][:caller].is_a?(Hash)
            oldest_call_waiting_start_timestamp = fifo[:callers][:caller][:timestamp]
            oldest_call_waiting_start_timestamp ||= time.to_s #due to some strange behaviour - there are data call without position and other needed params
          else
            oldest_call_waiting_start_timestamp = fifo[:callers][:caller].find{|call| call[:position].to_i == 1}[:timestamp]
          end
          report[:queue_max_waiting_time] = (time - Time.parse(oldest_call_waiting_start_timestamp)).to_i
        end
        reports << report
      end

      return reports
    end
  end
end
end 


