require 'snmp'

module Opstat
module Plugins
class Snmp < Task
  def initialize (name, queue, config)
    merged_config = default_config.merge(config)
    super(name, queue, merged_config)
    @snmp_host = merged_config['host']
    @snmp_oid = merged_config['oid']
    @snmp_device_type = merged_config['device_type']
    @snmp_device_location = merged_config['device_location']
    @snmp_device_description = merged_config['device_description']
    self
  end

  def parse
    @count_number += 1
    report = {}
    SNMP::Manager.open(:host => @snmp_host) do |manager|
      response = manager.get(@snmp_oid)
      unless response.nil?
        report['value'] = response.varbind_list.first.value.to_f
        report['device_type'] = @snmp_device_type
        report['device_location'] = @snmp_device_location
        report['device_description'] = @snmp_device_description
      end
    return report
    end
  end

  def default_config
    {
      'host' => '127.0.0.1',
      'oid' => '0',
      'device_type' => nil,
      'device_location' => nil,
      'device_description' => nil,
    }
end

end
end
end
