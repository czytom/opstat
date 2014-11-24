#!/usr/bin/env ruby

#TODO don't allow ip_addres of loopback

  module TaskServer
    extend Opstat::Logging
    def self.save(queue_data)
      oplogger.debug queue_data

      hostname = queue_data["hostname"]
      ip = queue_data['ip_address']
      queue_data["collected_data"].each do |data|
        host = Host.find_or_create_by_hostname_and_ip_address(hostname,ip)
        plugin = Plugin.find_or_create_by_type_and_host_id(data['plugin'],host.id)
        ##TODO reconsider if it is really needed
      #client_host.touch
          ##TODO reconsider if it is really needed
        #  client_host_plugin.touch
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
