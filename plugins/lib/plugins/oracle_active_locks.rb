require 'erb'

module Opstat
module Plugins
class OracleActiveLocks < Task

  def initialize (name, queue, config)
    super(name, queue, config)
p config
    self
    @su_user = config['su_user']
    @db_user = config['db_user']
    @db_password = config['db_password']
  end

  def sql_cmd
    @query ||= ERB.new <<-EOF
su - <%= @su_user %> -c 'echo "     set pagesize 10000
               set heading on
               column dummy noprint
               column  username    format a19     heading \\"User Name\\"
               column  active_locks    format 999999999999  heading \\"Active Locks\\"

               SELECT DISTINCT
                 CASE WHEN s.username IS NULL THEN '\\''USER#'\\'' || s.user# ELSE s.username END AS username,
                 COALESCE(l.active_locks_count, 0) AS active_locks_count
               FROM v\\$session s
               LEFT JOIN (
                 SELECT oracle_username, COUNT(*) AS active_locks_count
                 FROM v\\$locked_object
                 GROUP BY oracle_username
               ) l ON s.username = l.oracle_username;
              "|sqlplus -S <%= @db_user %>/<%= @db_password %>'
EOF
puts @query.result(binding)
@query
  end

  def parse
    report = []
    @cmd ||= sql_cmd.result(binding)
    oracle_output = IO.popen(@cmd)
    report  = oracle_output.readlines.join
    oracle_output.close
    oplogger.debug report
    return report
  end

end
end
end
