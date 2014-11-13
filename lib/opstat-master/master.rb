#!/usr/bin/env ruby

#TODO don't allow ip_addres of loopback
##TOD plugins save hostname

  module TaskServer
    extend Opstat::Logging
    def self.save(queue_data)
      oplogger.debug queue_data

      hostname = queue_data["hostname"]
      ip = queue_data['ip_address']
      #get client id from request and find client
      #TODO change - for now hardcoded for transitional period
      ##TODO add client creation
      client = Client.first(:login => 'powermedia')#.hosts.find_or_create_by_hostname_and_ip_address(hostname, ip)
      #find host
      #There should be only one
      queue_data["collected_data"].each do |data|
        client_host = client.hosts.select{|h| h.hostname == hostname and h.ip_address == ip}.first
        #REFACTOR
        if client_host.nil?
          puts "NEW HOST"
          new_host =  Host.new(:hostname => hostname, :ip_address => ip) 
          new_plugin = Plugin.new(:name => data['plugin'])
          client.hosts.push(new_host) 
          new_host.plugins.push(new_plugin)
          client.save
          client_host = new_host
        end
        #check if plugin exists
        #there also should be only one plugin
        client_host_plugin = client_host.plugins.select{|p| p.name == data['plugin']}.first
        ##TODO reconsider if it is really needed
   #   client_host.touch
        if client_host_plugin.nil?
          puts "new plugin"
          new_plugin = Plugin.new(:name => data['plugin'])
          client_host.plugins.push(new_plugin)
          client.save
          client_host_plugin = client_host.plugins.select{|p| p.name == data['plugin']}.first
          ##TODO reconsider if it is really needed
          #	client_host_plugin.touch
        end
        #Plugins.find_or_create_by_plugin_and_ip_address_and_hostname( plugin_name, ip, hostname).touch
        Opstat::Parsers::Master.instance.parse_and_save(:host => client_host, :plugin_data => data, :plugin => client_host_plugin)
        #parser = Opstat::Parsers::Master.instance.get_parser(plugin_name)
        #parser.save_data(time, client_host.id, data, client_host_plugin.id)
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
