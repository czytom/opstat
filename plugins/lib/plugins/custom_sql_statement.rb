require 'active_record'

module Opstat
module Plugins
class CustomSqlStatement < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
    @db_config = config['db_config']
    @query - config['sql_query']
    ActiveRecord::Base.establish_connection @dbconfig
  end

  def parse
    report = ActiveRecord::Base.connection.execute(@query)
    return report
  end

end
end
end
#need:
#activerecord gem
