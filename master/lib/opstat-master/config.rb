require 'yaml'
module Opstat
  # A pretty sucky config class, ripe for refactoring/improving
  class Config
    include Singleton

    def initialize
      @configured = false
      @config = ''
      @config_file = ''
      #TODO set defaults
    end

    def load_config(config_file)
      #set_config_defaults(configfile)
      @config_file = config_file
      @config = YAML.load_file(config_file)
      self.set_defaults
    end

    def set_defaults
      @config['client']['send_data_interval'] ||= 30
      @config['client']['log_level'] ||= "WARN"
    end

    def get_mongo_config_file_path
      "#{File.dirname(@config_file)}/mongoid.yml"
    end

    def get_influx_config
       get('influxdb')
    end

    def get_mq_config
       get('mq')
    end

    def get(key)
      @config[key]
    end

    def init_config(options)
      load_config(options[:config_file])
      set_defaults
      @config[:config_file] = options[:config_file]
    end

  end
end
