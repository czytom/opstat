module OPStat
module DB
  class Influx
    include Singleton
    def initialize
      @config = Opstat::Config.instance.get_influx_config
      @influxdb = InfluxDB::Client.new @config
#      @influxdb = InfluxDB::Client.new @config['database'], username: username, password: password, time_precision: time_precision
    end

    def write_point(name, measurement)
      @influxdb.write_point(name, measurement)
    end
  end
end
end
