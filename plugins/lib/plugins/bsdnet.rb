module Opstat
module Plugins
class Bsdnet < Task
  def parse
    io = IO.popen("pfctl -sinfo")
    report = io.readlines
    io.close
    return report
  end
end
end
end
