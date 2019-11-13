require 'yaml'
module Opstat
module Plugins
class HpPdu < Task
  def initialize (name, queue, config)
    super(name, queue, config)
    @snmp_host = config['snmp_host']
    @snmp_port = config['snmp_port']
    pwd  = File.dirname(File.expand_path(__FILE__))
    snmp_ids = YAML::load_file("#{pwd}/../data/hp_pdu.yml").keys.join(' ')
    @snmp_cmd = "snmpget -c public -v2c #{@snmp_host}:#{@snmp_port} #{snmp_ids}"
  end

  def parse
    snmp_io = IO.popen(@snmp_cmd)
    report  = snmp_io.readlines.join
    snmp_io.close
    return report
  end

end
end
end
