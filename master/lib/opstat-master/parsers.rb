module Opstat
module Parsers
  class Master
    include Opstat::Logging
    include Singleton
    def initialize
      @parsers = {}
    end
    def load_parsers
      @parsers = Opstat::Plugins.load_parsers(oplogger)
    end

    def parse_and_save(params)
      plugin = params[:plugin]
      host = params[:host]
      data = params[:plugin_data]['data']
      time = Time.parse(params[:plugin_data]['timestamp'])
      oplogger.info "Parsing data collected on #{time} from (plugin:#{plugin[:type]} #{host[:hostname]}) "
      begin
        reports = @parsers[plugin[:type]].parse_data(data: data, time: time)
      #TODO save errors to db
      rescue Exception => e
        oplogger.error "current params #{params}"
	return 
	raise e
      end
      if reports.nil? or reports.empty?
        oplogger.warn "no report data parsed - empty report for #{plugin[:type]}?"
        return
      end
      reports.each do |report|
	default_tags = { :hostname => host[:hostname] }
        report[:tags] ||= {}
        measurement_tags = report[:tags].merge(default_tags)
	begin

        measurement = { :values => report[:values], :timestamp => report[:time].to_time.to_i, :tags => measurement_tags, :name => plugin['type'] }
        oplogger.info "Saving parsed data collected on #{time} from (plugin:#{plugin[:type]} #{host[:hostname]}) "
	Opstat::DB::Influx.instance.write_point(plugin[:type], measurement)
	rescue 
	next
	end

      end
    end
  end	     
end
end
