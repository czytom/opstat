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
      time = params[:time]
      data = params[:data]
      reports = @parsers[plugin.name].parse_data(data)
      oplogger.info "Saving parsed data from #{host.id} on #{time}"
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
end

class Client
  #TODO - definition in single place
  include MongoMapper::Document
  many :hosts
  set_collection_name "opstat.clients"
  timestamps!
end

class Host
  include MongoMapper::EmbeddedDocument
  many :plugins
  timestamps!
  embedded_in :client
end

class Plugin
  include MongoMapper::EmbeddedDocument
  timestamps!
  embedded_in :host
end

