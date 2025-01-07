require 'erb'

module Opstat
module Plugins
class FreeswitchUnansweredCalls < Task
  def initialize (name, queue, config)
    super(name, queue, config)
    @calls_cmd_template = config['cmd_template']
    self
  end

  def parse
    @count_number += 1
    report = `#{calls_get_cmd}`
    return report
  end

  def calls_get_cmd
    ERB.new(@calls_cmd_template).result( binding )
  end

  def sql
    sql = "SELECT inbound.caller_id_number, inbound.destination_number, datetime(inbound.start_stamp,'utc') as time, datetime(inbound.answer_stamp,'utc') as answer_stamp, datetime(inbound.end_stamp,'utc') as end_stamp, inbound.duration, inbound.billsec FROM cdr inbound left join cdr out on inbound.uuid=out.bleg_uuid  WHERE inbound.context='power-fifos' and inbound.start_stamp >= date('now') and out.start_stamp is null order by inbound.start_stamp asc;"
    return sql
  end
end
end
end
