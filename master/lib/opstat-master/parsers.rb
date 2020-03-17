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
      collect_time = Time.parse(params[:plugin_data]['timestamp'])
      oplogger.info "Saving parsed data collected on #{collect_time} from #{host.id}(plugin:#{plugin[:type]} #{host[:hostname]}) "
      begin
        reports = @parsers[plugin[:type]].parse_data(data: data, time: collect_time)
        if reports.nil? or reports.empty?
          oplogger.warn "no report data parsed - empty report for #{plugin.type}?"
          raise "No report data parsed - empty report for #{plugin.type}?"
        end
      rescue Exception => e
        oplogger.error "current params #{params}"
        puts '#######################'
        ExceptionNotifier.notify_exception(e, {data: {reports: reports, params: params}})
        return
      end
      reports.each do |report|
	default_tags = { :host_id => host.id, :plugin_id => plugin.id, :hostname => host[:hostname] }
	report[:tags] ||= {}
	measurement_tags = report[:tags].merge(default_tags)
	measurement = { :values => report[:values], :timestamp => report[:time].to_i, :tags => measurement_tags, :name => plugin.type }
	Opstat::DB::Influx.instance.write_point(plugin.type, measurement)
      end
    end
  end	     
end
end

class Report
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  store_in collection: "opstat.reports"
end

class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  store_in collection: "opstat.users"
end

class Host
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  store_in collection: "opstat.hosts"
  has_many :plugins
end

class Plugin
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  store_in collection: "opstat.plugins"
  belongs_to :host
end

