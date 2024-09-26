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

	report_data = report.select{|k,v| not k.to_s.starts_with?('OPSTAT_TAG_')}
	report_tags = report.select{|k,v| k.to_s.starts_with?('OPSTAT_TAG_')}
	report_tags ||= {}
	measurement_tags = report_tags.merge(default_tags)
	measurement = { :values => report_data, :timestamp => time.to_i, :tags => measurement_tags, :name => plugin_type }
	Opstat::DB::Influx.instance.write_point(plugin_type, measurement)
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

