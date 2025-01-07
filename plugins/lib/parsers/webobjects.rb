require 'json'

module Opstat
module Parsers
  class Webobjects
    include Opstat::Logging

    def parse_data(data:, time:)
      return if data.length == 0
      reports = []
      prepared_data = data.gsub('"id"','"instance_id"')
      webobjects_json_stats = JSON::parse(prepared_data)
      webobjects_json_stats.select{|s| s['state'] == 'ALIVE'}.each do |instance_stats|
        webobjects_stats = {:time => time, :values => {
          'active_sessions': instance_stats['activeSessions'].to_i,
          'transactions': instance_stats['transactions'].to_i,
          'average_idle_period': instance_stats['averageIdlePeriod'].to_f,
          'average_transaction_time': instance_stats['avgTransactionTime'].to_f,
          'deaths': instance_stats['deaths'].to_i,
          'refusing_new_sessions': instance_stats['refusingNewSessions'],
          'auto_recover': instance_stats['autoRecover'].downcase == 'true',
          },
          :tags => {
            'OPSTAT_TAG_wo_instance_id': instance_stats['instance_id'],
            'OPSTAT_TAG_wo_host': instance_stats['host'],
            'OPSTAT_TAG_wo_app': instance_stats['name']
          }
        }
        reports << webobjects_stats
      end
      return reports
    end
  end
end
end

