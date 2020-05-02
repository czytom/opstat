require 'yaml'
module Opstat
  class Config
  include Opstat::Logging
    include Singleton

    def initialize
      @configured = false
      @config = ''
    end

    def load_config(config_file)
      system_config_dir = '/etc/opstat'
      system_config_path = system_config_dir + '/opstat.yml'
      system_plugins_config_dir = system_config_dir + '/plugins/'
      unless File.exists?(config_file)
        preconfig_logger.info 'No config file - create config file with default settings. Please set correct MQ settings'
        default_config_path = File.dirname(File.expand_path(__FILE__)) + '/config/opstat.yml'
	FileUtils.mkdir(system_config_dir) unless File.exists?(system_config_dir)
	FileUtils.mkdir(system_plugins_config_dir) unless File.exists?(system_plugins_config_dir)
	FileUtils.cp(default_config_path,system_config_path)
      end
      preconfig_logger.info "Loading config from #{config_file}"
      @config = YAML.load_file(config_file)
      Dir.glob(system_plugins_config_dir + '*.yml').each do |file|
        preconfig_logger.info "Loading config from #{file}"
        @config['plugins'][File.basename(file,'.yml')] = YAML.load_file(file)
      end
      self.set_defaults
    end

    def set_defaults
      @config['client']['send_data_interval'] ||= 30
      @config['client']['log_level'] ||= "WARN"
    end

    def get(key)
      @config[key]
    end

    def get_mq_config
      get('mq')
    end

    def init_config(options)
      load_config(options[:config_file])
      set_defaults
      @config[:config_file] = options[:config_file]
    end

  end
end
options = {}
optparse = OptionParser.new do|opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Usage: command [options]"

  options[:verbose] = false
    opts.on( '-v', '--verbose', 'Output more information' ) do
    options[:verbose] = true
  end

  opts.on( '-c', '--config-file String', :required,  "Config file path" ) do|l|
    options[:config_file] = l
  end
  options[:config_file] ||= '/etc/opstat/opstat.yml'

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end
optparse.parse!

Opstat::Config.instance.init_config(options)
