require 'socket'

module Opstat
module Plugins

class HaproxyTables < Task
  def initialize (name, queue, config)
    super(name, queue, config)
    @haproxy_socket = config['socket']
    raise ArgumentError, "Socket #{path} doesn't exists or is not a UNIX socket" unless File.exists?(@haproxy_socket) and File.socket?(@haproxy_socket)
    self
  end

  def parse
    report = []
    begin
      UNIXSocket.open(@haproxy_socket) do |socket|
        socket.puts('show table')
        report = socket.readlines
      end
    rescue
      nil
    end
    return report
  end
end
end
end
