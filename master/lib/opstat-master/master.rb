#!/usr/bin/env ruby

  module TaskServer
    extend Opstat::Logging
    def self.save(queue_data)
      oplogger.debug queue_data

      hostname = queue_data["hostname"]
      ip = queue_data['ip_address']
      client_version = queue_data['version']
      send_data_interval = queue_data['send_data_interval']

      queue_data["collected_data"].each do |data|
        host = Host.find_or_create_by(hostname: hostname, ip_address: ip)
        plugin = Plugin.find_or_create_by(type: data['plugin'], host_id: host.id)
	host['send_data_interval'] = send_data_interval
	plugin['interval'] = data['interval']
	plugin_dead_ratio = 2
	unless plugin['interval'].nil?
	  if plugin['interval'] > host['send_data_interval']
	    plugin_is_alive_interval = data['interval'] * plugin_dead_ratio
	  else
	    plugin_is_alive_interval = host['send_data_interval'] * plugin_dead_ratio
	  end
	  plugin['is_alive_time'] = Time.now + plugin_is_alive_interval
	end

        plugin.save
        Opstat::Parsers::Master.instance.parse_and_save(:host => host, :plugin_data => data, :plugin => plugin)
      end
    end
  end

module Opstat
module Master
extend Opstat::Logging
def self.main_loop
  mq_config = Opstat::Config.instance.get_mq_config
  Opstat::Parsers::Master.instance.load_parsers
  oplogger.info 'START'
  EventMachine::run do
    AMQP.start(mq_config) do |connection|
      oplogger.info "Connecting to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

      channel  = AMQP::Channel.new(connection,:auto_recovery => true)
      ampqqueue    = channel.queue(mq_config['queue_name'],:auto_delete => false, :durable => true)
      connection.on_tcp_connection_loss do |conn, settings|
        oplogger.error "[network failure] Trying to reconnect..."
        conn.reconnect(false, 2)
      end

      ampqqueue.subscribe(:ack => true) do |metadata,payload|
        TaskServer::save(JSON.parse(payload))
        metadata.ack
      end
    end
  end 
end
end
end
