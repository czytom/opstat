module Opstat
module Plugins
class Cpu < Task
  STAT_FILE = "/proc/stat"

  def parse
    report = File.readlines(STAT_FILE)
    return report
  end

end
end
end
