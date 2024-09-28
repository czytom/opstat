#!/usr/bin/env ruby
require 'yaml'
require 'socket'

include Opstat::Common


module Opstat
module SendData
  extend Logging
  def self.send_from_queue(q, ex, name)
    #TODO cache-evealuate only at start time
    begin
      @hostname ||= Socket.gethostname
      @ip_address ||= Socket::getaddrinfo(@hostname,"echo",Socket::AF_INET)[0][3]
      data_to_send = {:collected_data => []}


      1.upto(q.size) do
        q.pop do |data|
          data_to_send[:collected_data] << data
        end
      end

      # TODO auto register - assign some unique id for a new host instead of hostname, ip_address pai
      data_to_send[:hostname] = @hostname
      data_to_send[:ip_address] = @ip_address
      data_to_send[:version] = Opstat::VERSION
      custom_tags = Opstat::Config.instance.get('client')['custom_tags']
      data_to_send[:custom_tags] = Opstat::Config.instance.get('client')['custom_tags'] if custom_tags
      data_to_send[:send_data_interval] = Opstat::Config.instance.get('client')['send_data_interval']

      ex.publish data_to_send.to_json, :routing_key => name
    rescue SocketError
      raise "Unable to resolve hostname #{Socket.gethostname}"
    end
  end

  def unbind
    oplogger.info 'AMQP Connection closed'
#    EventMachine::stop_event_loop
  end
end #module SendData



module Client
  extend Logging
  def self.main_loop
    oplogger.info 'Starting client main loop'
    queue = EM::Queue.new
    mq_config = Opstat::Config.instance.get_mq_config
    send_data_interval = Opstat::Config.instance.get('client')['send_data_interval']
    @a_plugins = Opstat::Plugins.create_plugins(queue)
    EventMachine::run do
      AMQP.start(mq_config) do |connection|
        connection.on_tcp_connection_loss do |conn, settings|
          oplogger.warn "[network failure] Trying to reconnect..."
          conn.reconnect(false, 2)
        end

        oplogger.info "Connecting to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

        channel  = AMQP::Channel.new(connection,:auto_recovery => true)
        channel.on_error do |ch, channel_close|
         oplogger.error "AMQP channel error"
         raise channel_close.reply_text
        end

        ampqqueue    = channel.queue(mq_config['queue_name'], :auto_delete => false, :durable => true)
        exchange = channel.default_exchange

        @a_plugins.each do |task|
          if task.external_plugin_needed?
            task.set_external_plugin = EventMachine::open_datagram_socket task.external_plugin['address'], task.external_plugin['port'], Opstat::Plugins::UDPExternalPlugins::Apache2, task.external_plugin
	  end
          EventMachine::add_periodic_timer(task.interval) {task.parse_and_queue}
        end 
 
        EventMachine::add_periodic_timer(send_data_interval) { Opstat::SendData.send_from_queue(queue, exchange, ampqqueue.name) }
      end
    end #EventMachine::run do
  end
end
end
