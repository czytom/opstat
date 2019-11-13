module Opstat
module Plugins
class Xen < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  def parse
    report = {}
    xen_io = IO.popen('xentop -i 1 -b -f')
    report  = xen_io.readlines.join
    xen_io.close
    return report
  end

end
end
end
