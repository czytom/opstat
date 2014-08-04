module Opstat
module Parsers
  class Fpm
    require 'json'
    include Opstat::Logging

    def save_data(data)
      begin
        return if data.nil?
	report = {}
	report[:pools] = []
        oplogger.debug data
        data.each_pair do |pool, stats|
          values = JSON::parse(stats)
          report[:pools] << {
	    :pool => values['pool'],
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
      rescue
	#TODO - set some error message in db
      return report
    end
  end
end
end
