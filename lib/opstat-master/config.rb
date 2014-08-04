module Opstat
  # A pretty sucky config class, ripe for refactoring/improving
  class Config
    include Singleton

    def initialize
      @configured = false
      @config = ''
      #TODO set defaults
    end

    def load_config(config_file)
      #set_config_defaults(configfile)
      @config = YAML.load_file(config_file)
      self.set_defaults
    end

    def set_defaults
      @config['client']['send_data_interval'] ||= 30
      @config['client']['log_level'] ||= "WARN"
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
