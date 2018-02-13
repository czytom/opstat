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
      reports = @parsers[plugin[:type]].parse_data(data)
      #TODO save errors to db
      return if reports.nil?
      reports.each do |report|
        rp = report.merge({ :timestamp => time, :host_id => host[:id], :plugin_id => plugin[:id], :plugin_type => plugin[:type]})
        Report.create(rp)
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

