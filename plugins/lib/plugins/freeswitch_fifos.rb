require 'xmlhasher'

module Opstat
module Plugins
class FreeswitchFifos < Task
  def initialize (name, queue, config)
    merged_config = default_config.merge(config)
    super(name, queue, merged_config)
    @fifo_report_cmd = merged_config['fifo_report_cmd']
    self
  end

  def parse
    @count_number += 1
    report = `#{@fifo_report_cmd}`
    return report
  end

  def default_config
    { 
      'fifo_report_cmd' => 'fs_cli -x \'fifo list\''
    }
  end

end
end
end
