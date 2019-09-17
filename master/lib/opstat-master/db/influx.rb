module Opstat
module DB
  class Influx
    include Singleton
    include Opstat::Logging
    def initialize
      @config = Opstat::Config.instance.get_influx_config
      @influxdb = InfluxDB::Client.new @config
      @influxdb = InfluxDB::Client.new @config['database'], username: @config['username'], password: @config['password'], time_precision: @config['time_precision']
    end

    def write_point(name, measurement)
      begin
        retries ||= 0
        oplogger.info "writing stats problem saving data - try ##{ retries }"
        @influxdb.write_point(name, measurement)
      rescue InfluxDB::Error
        sleep 5
        retry if (retries += 1) < 3
      end
    end
  end
end
end
