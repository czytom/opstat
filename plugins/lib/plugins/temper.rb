module Opstat
module Plugins
class Temper < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    temper_io = IO.popen('/usr/bin/temper')
    report  = temper_io.readlines
    temper_io.close
    return report[0].to_s
  end

end
end
end
