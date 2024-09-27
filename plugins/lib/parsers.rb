module Opstat
module Parsers
  class Parser
    @@parsers = nil

    def self.load_parsers(oplogger)
      return @@parsers if @@parsers

      pwd  = File.dirname(File.expand_path(__FILE__))
      @@parsers = {}

      Dir.glob(File.expand_path("#{pwd}/parsers/*.rb")).each do |file|
        require file
        plugin_name = File.basename(file, '.*')
        plugin_class = "Opstat::Parsers::#{classify(plugin_name)}"
          
        oplogger.info "Loading parser #{plugin_name}"
          
        begin
          @@parsers[plugin_name] ||= Opstat::Common.constantize(plugin_class).new
        rescue NameError => e
          oplogger.error "Failed to load parser for #{plugin_name}: #{e.message}"
        end
      end
      @@parsers
    end

    def self.classify(file_name)
      file_name.split('_').map(&:capitalize).join
    end

    def self.get_parser(plugin_name)
      @@parsers[plugin_name]
    end

    def parse_data(params)
      data = extract_data(params)
      time = extract_time(params)
      hostname= extract_hostname(params)
      plugin_type = extract_plugin_type(params)

      oplogger.info "Saving parsed data collected on #{time} from #{hostname}(plugin:#{plugin_type}) "
      parse_specific_data(data: data, time: time, hostname: hostname, plugin_type: plugin_type)
    end

    def extract_data(params)
      params[:data]
    end

    def extract_time(params)
      params[:time]
    end

    def extract_hostname(params)
      params[:host][:hostname]
    end

    def extract_plugin_type(params)
      params[:plugin][:type]
    end

    def parse_specific_data(data:, time:, hostname:, plugin_type:)
      raise NotImplementedError, "You must implement `parse_specific_data` in subclasses"
    end

    def build_default_tags(params)
      params[:host][:hostname]
    end
  end
end
end
