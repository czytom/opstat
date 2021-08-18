module Opstat
module Plugins
class Disk < Task
  DISK_IO_STATS_FILE = "/proc/diskstats"

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  #TODO in memory module io.close
  def parse
    @count_number += 1
    report = {}
    report['disk_space'] = space_usage
    report['disk_io'] = disk_io_usage
    return report
  end
  def space_usage
    io = IO.popen('df --output=source,fstype,used,avail,itotal,iused,iavail,target|sed "s#/dev/root#/dev/$(readlink /dev/root)#"')
    stats = io.readlines
    io.close
    return stats
  end
  def disk_io_usage
    stats = File.open(DISK_IO_STATS_FILE).readlines
    return stats
  end
end
end
end
