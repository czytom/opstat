module Opstat
module DB
  class Influx
    include Singleton
    include Opstat::Logging
    def initialize
      @config = Opstat::Config.instance.get_influx_config
      @influxdb = InfluxDB::Client.new @config['database'], username: @config['username'], password: @config['password'], time_precision: @config['time_precision']
    end

    def write_point(name, measurement)
      begin
        retries ||= 0
        @influxdb.write_point(name, measurement)
      rescue InfluxDB::Error => e
        oplogger.info "writing stats problem saving data - try ##{ retries }. Next try in 2 seconds"
        sleep 2
	p e.message
	p measurement
        if (retries += 1) < 2
	  retry
	else
	  raise InfluxDB::Error
	end
      end
    end
  end
end
end
