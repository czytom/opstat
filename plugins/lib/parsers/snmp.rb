module Opstat
module Parsers
  class Snmp
    include Opstat::Logging

    def parse_data(data:, time:)

      reports = [{:time => time, :tags => {
        :OPSTAT_TAG_device_type => data['device_type'],
        :OPSTAT_TAG_device_location => data['device_location'],
        :OPSTAT_TAG_device_description => data['device_description'],
        },
        :values => {'value' => data['value']}
      }]
    end
  end
end
end
