#set default FACTERDIR - omit libfacter not found on some systems
facter_paths = ['/usr','/usr/lib']
facter_paths <<  ENV['FACTERDIR'] unless ENV['FACTERDIR'].nil?
begin
  facter_path = facter_paths.pop
  ENV['FACTERDIR'] = facter_path
  puts "Try to load facter lib with FACTERDIR path set to #{facter_path}"
  require 'facter'
rescue LoadError => e
  retry if facter_paths.count > 0
  raise e
end

module Opstat
module Plugins
class Facts < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
  end

  #TODO in memory module io.close
  def parse
    @count_number += 1
    return ::Facter.to_hash
  end
end
end
end
