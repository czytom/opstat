module Opstat
module Parsers
  class Master
    include Opstat::Logging
    include Singleton

    def load_parsers
      @parsers = Opstat::Plugins.load_parsers(oplogger)
    end

    def parse_and_save(params)
      begin
        reports = @parsers[plugin[:type]].parse_data(data: data, time: time)
      #TODO save errors to db
      rescue Exception => e
        oplogger.error "current params #{params}"
	raise e
      end
      if reports.nil? or reports.empty?
        oplogger.warn "no report data parsed - empty report for #{plugin.type}?"
        return
      end
      reports.each do |report|
	Opstat::DB::Influx.instance.write_point(plugin_type, report)
      end
    end
  end	     
end
end
