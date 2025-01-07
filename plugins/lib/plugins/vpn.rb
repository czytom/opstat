module Opstat
module Plugins
class Vpn < Task
  STAT_FILE = "/var/log/openvpn-status.log"

  def parse
    report = File.readlines(STAT_FILE)
    return report
  end

end
end
end
