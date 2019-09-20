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
      oplogger.info "Saving parsed data collected on #{time} from #{host.id}(plugin:#{plugin[:type]} #{host[:hostname]}) "
      begin
        reports = @parsers[plugin[:type]].parse_data(data: data, time: time)
      #TODO save errors to db
      rescue Exception => e
        oplogger.error "current params #{params}"
        ExceptionNotifier.notify_exception(e, {data: {reports: reports, params: params}})
        return
      end
      if reports.nil? or reports.empty?
        oplogger.warn "no report data parsed - empty report for #{plugin.type}?"
        ExceptionNotifier.notify_exception(e, {data: {reports: reports, params: params}})
        return
      end
      reports.each do |report|
	default_tags = { :host_id => host.id, :plugin_id => plugin.id, :hostname => host[:hostname] }
	report_data = report.select{|k,v| not k.to_s.starts_with?('OPSTAT_TAG_')}
	report_tags = report.select{|k,v| k.to_s.starts_with?('OPSTAT_TAG_')}
	report_tags ||= {}
	measurement_tags = report_tags.merge(default_tags)
	measurement = { :values => report_data, :timestamp => time.to_i, :tags => measurement_tags, :name => plugin.type }
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

