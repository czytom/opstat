require 'erb'

module Opstat
module Plugins
class FreeswitchCalls < Task
  def initialize (name, queue, config)
    super(name, queue, config)
    @calls_cmd_template = config['cmd_template']
    @operators = config['operators']['contexts']
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
    number_to_name = @operators.values.flatten.map {|l| "when '#{l['number']}' then '#{l['name']}'"}.join(' ')
    number_to_department = @operators.values.flatten.map {|l| "when '#{l['number']}' then '#{l['department']}'"}.join(' ')
    where_clause = @operators.map {|context, operators| "(b.context='#{context}' and a.destination_number in (#{operators.map{|o| "'#{o['number']}'"}.join(',')}))"}.join(' or ')

    sql = "SELECT b.caller_id_number, datetime(a.start_stamp,'utc') as time, datetime(a.answer_stamp,'utc') as answer_stamp, datetime(a.end_stamp,'utc') as end_stamp, a.duration, a.billsec, case a.destination_number  #{number_to_name} end as operator, case a.destination_number #{number_to_department} end as department, a.destination_number FROM cdr a inner join cdr b on a.bleg_uuid = b.uuid WHERE a.hangup_cause='NORMAL_CLEARING' and a.answer_stamp >= date('now') and (#{where_clause})"
    return sql
    
  end
end
end
end

