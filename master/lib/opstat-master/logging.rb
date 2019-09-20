require 'log4r'

module Opstat
module Logging
  extend self
  def oplogger
    return @oplogger if @oplogger
    @oplogger = Log4r::Logger.new self.class.to_s
    @oplogger.level = @oplogger.levels.index(log_level)
    outputter = Log4r::Outputter.stdout
    outputter.formatter = Log4r::PatternFormatter.new(:pattern => "%l - %C - %m")
    @oplogger.outputters << outputter
    @oplogger
  end
  def log_level
    @log_level ||= Opstat::Config.instance.get('client')['log_level']
    @log_level
  end
end
end

