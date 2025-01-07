require 'net/http'
module Opstat
module Plugins

class Haproxy < Task
  def initialize (name, queue, config)
    super(name, queue, config)
    @haproxy_url = "#{config['url']}/;up/stats;csv;norefresh"
    self
  end
    def parse
      report = []
      begin
        uri = URI.parse(@haproxy_url)
        source = Net::HTTP.get(uri)
        source.each_line do |line|
          report << line
        end
      rescue Exception => e
        puts e
        nil
      end
    return report
    end
  end
end
end
