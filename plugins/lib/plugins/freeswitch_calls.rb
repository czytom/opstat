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
    where_clause = @operators.map {|context, operators| "(context='#{context}' and destination_number in (#{operators.map{|o| "'#{o['number']}'"}.join(',')}))"}.join(' or ')

    sql = "SELECT start_stamp as time, answer_stamp, end_stamp, duration, billsec, case destination_number  #{number_to_name} end as operator, destination_number FROM cdr WHERE hangup_cause='NORMAL_CLEARING' and answer_stamp >= date('now') and (#{where_clause})"
    return sql
    
  end
end
end
end
