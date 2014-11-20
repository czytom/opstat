module Opstat
module Parsers
  class Master
    include Opstat::Logging
    include Singleton
    def initialize
      @parsers = {}
    end
    def load_parsers
      pwd  = File.dirname(File.expand_path(__FILE__))
      Dir.glob(File.expand_path("#{pwd}/parsers/*.rb")).each do |file|
        require file
	plugin_name = File.basename(file,'.*')
	plugin_class = "Opstat::Parsers::#{plugin_name.capitalize}"
	oplogger.info "loading parser #{plugin_name}"
        @parsers[plugin_name] ||= Opstat::Common.constantize(plugin_class).new 
      end
    end

    def parse_and_save(params)
      plugin = params[:plugin]
      host = params[:host]
      data = params[:plugin_data]['data']
      time = Time.parse(params[:plugin_data]['timestamp'])
      reports = @parsers[plugin.name].parse_data(data)
      oplogger.info "Saving parsed data collected on #{time} from #{host.id}(plugin:#{plugin.name} #{host.hostname}) "
      reports.each do |report|
        rp = report.merge({ :timestamp => time, :host_id => host.id, :plugin_id => plugin.id, :plugin_type => plugin.name})
        Report.create(rp)
      end
    end
    def get_parser(plugin_name) #deprecated
      return @parsers[plugin_name] if @parsers.has_key?(plugin_name)
      plugin_class = "Opstat::Parsers::#{plugin_name.capitalize}"
      @parsers[plugin_name] = Opstat::Common.constantize(plugin_class).new
      @parsers[plugin_name]
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

