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
	host = {hostname: hostname, ip_address: ip}
	plugin = {type: data['plugin']}
	host['send_data_interval'] = send_data_interval
	plugin['interval'] = data['interval']
        Opstat::Parsers::Master.instance.parse_and_save(:host => host, :plugin_data => data, :plugin => plugin)
      end
    end
  end

#TODO EM AMQP reconnect
##TODO - AMQP config data from /etc
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
