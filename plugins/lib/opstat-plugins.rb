require_relative 'version.rb'
require_relative 'logging.rb'
require_relative 'parsers.rb'
module Opstat
  module Plugins
    def self.load_models
      pwd  = File.dirname(File.expand_path(__FILE__))
      Dir.glob(File.expand_path("#{pwd}/app/models/*.rb")).each do |file|
        puts "loading #{file}"
        filename = File.basename(file, '.*')
        class_name_symbol = filename.classify.to_sym
        #autoload class_name_symbol, "#{pwd}/app/models/#{filename}"
        require "#{pwd}/app/models/#{filename}"
      end
    end

    def self.load_parser(name)
      pwd  = File.dirname(File.expand_path(__FILE__))
      require pwd + "/parsers/#{name}.rb"
    end

    def self.load_plugin(name)
      pwd  = File.dirname(File.expand_path(__FILE__))
      require pwd + "/plugins/#{name}.rb"
    end

    module Models
      attr_reader :data_type
      def data_type(type)
        @data_type = type
      end
    end
  end
end
