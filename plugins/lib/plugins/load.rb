module Opstat
module Plugins
class Load < Task
  STAT_FILE = "/proc/loadavg"

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    @count_number += 1
    report = Array.new
    report << File.foreach(STAT_FILE).first
    return report
  end
end
end
end
