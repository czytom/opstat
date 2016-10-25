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
      oplogger.info "Saving parsed data collected on #{time} from #{host.id}(plugin:#{plugin.type} #{host.hostname}) "
      reports = @parsers[plugin.type].parse_data(data)
      #TODO save errors to db
      return if reports.nil?
      reports.each do |report|
        rp = report.merge({ :timestamp => time, :host_id => host.id, :plugin_id => plugin.id, :plugin_type => plugin.type})
        Report.create(rp)
      end
    end
  end	     
end
end

class Report
  include MongoMapper::Document
  set_collection_name "opstat.reports"
end

class User
  include MongoMapper::Document
  set_collection_name "opstat.users"
  timestamps!
end

class Host
  include MongoMapper::Document
  set_collection_name "opstat.hosts"
  many :plugins
  timestamps!
end

class Plugin
  include MongoMapper::Document
  set_collection_name "opstat.plugins"
  key :host_id
  belongs_to :host
  timestamps!
end

