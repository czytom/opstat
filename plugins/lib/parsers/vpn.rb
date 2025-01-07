module Opstat
module Parsers
  class Vpn
    include Opstat::Logging

    def parse_data(data:, time:)
      reports = []
      updated_info_index = 1
      first_client_index = 3
      last_client_index = data.find_index("ROUTING TABLE\n") - 1
      time = Time.parse(data[updated_info_index])

      data[first_client_index..last_client_index].each do |client_data|
        client, ip, bytes_received, bytes_sent, *rest = client_data.split(',')
        reports << {:time => time, :tags => {:client => client }, :values => {:bytes_received => bytes_received.to_i, :bytes_sent => bytes_sent.to_i}}
      end
      return reports
    end
  end
end
end

