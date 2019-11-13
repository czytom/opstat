module Opstat
module Parsers
  class Fpm
    require 'json'
    include Opstat::Logging

    def parse_data(data:, time:)
      begin
        return [] if data.nil?
	reports = []
        data.each do |pool_stats|
          values = JSON::parse(pool_stats[-1])
          reports << {
	    :OPSTAT_TAG_pool => values['pool'],
	    :accepted_connections => values['accepted conn'],
	    :listen_queue => values['listen queue'],
	    :listen_queue_length => values['listen queue len'],
	    :listen_queue_max => values['max listen queue'],
	    :processes_idle => values['idle processes'],
	    :processes_active => values['active processes'],
	    :processes_active_max => values['max active processes'],
	    :children_max => values['max children reached']
          }
        end
      end
      return reports
    end
  end
end
end
