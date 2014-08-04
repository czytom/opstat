dbconfig = YAML::load( File.open( File.expand_path( File.dirname(__FILE__) + '/databaseConn.yml' ) ) )
ActiveRecord::Base.establish_connection(dbconfig)
