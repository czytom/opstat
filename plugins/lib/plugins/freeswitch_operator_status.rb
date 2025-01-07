require 'erb'

module Opstat
module Plugins
class FreeswitchOperatorStatus < Task
  def initialize (name, queue, config)
    super(name, queue, config)
    @operator_status_cmd_template = config['cmd_template']
    @operators = config['operators']['contexts']
    self
  end

  def parse
    @count_number += 1
    report = {}
    report[:active] = `#{operator_status_get_cmd}`
    report[:all] = operators_data
    return report
  end

  def operator_status_get_cmd
    p ERB.new(@operator_status_cmd_template).result( binding )
    ERB.new(@operator_status_cmd_template).result( binding )
  end

  def operators_data
    @operators.values.flatten
  end

  def sql
    sql = "select fifo_name,originate_string,start_time from fifo_outbound where start_time<>0 and stop_time=0"
    return sql
  end
end
end
end


