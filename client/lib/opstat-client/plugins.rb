module Opstat
module Plugins
extend Opstat::Logging
  def self.create_plugins(queue)
    plugins = []
    Opstat::Config.instance.get('plugins').each_pair do |name, conf|
      if conf.is_a?(Array)
        conf.each do |plugin_instance_config|
          task = Opstat::Plugins.create_task_from_config(name, queue, plugin_instance_config)
          plugins << task
        end
      else
        task = Opstat::Plugins.create_task_from_config(name, queue, conf)
        plugins << task
      end
    end
    plugins
  end
  
  def self.create_task_from_config(name, queue, conf)
    conf['log_level'] ||=  Opstat::Config.instance.get('client')['log_level']
    oplogger.info "Loading #{name} plugin with properties #{conf.inspect}"
    Opstat::Plugins.load_plugin(name)
    plugin_name = name
    class_name = "Opstat::Plugins::#{name}"
    task = Opstat::Common.constantize(class_name).new(plugin_name, queue, conf)
    return task
  end


class Task
  include Opstat::Logging
  attr_accessor :interval, :next_run

  def initialize (name, queue, config)
    @name = name
    @queue = queue
    @interval = config['interval']
    @interval ||= 60
    @data_sended = {}
    @count_number = 0
    @send_number = 0
    @log_level = config['log_level']
    @run = config['run']
    @external_plugin = config['external_plugin']
  end

  def parse_and_queue
    oplogger.info "collecting stats"
    report = parse
    oplogger.debug report
    @queue.push({ :timestamp => Time.now, :plugin => @name, :data => report, :interval => @interval})
  end

  def external_plugin_needed?
    if @external_plugin.nil?
      return false
    end
    return true
  end

end
end
end
