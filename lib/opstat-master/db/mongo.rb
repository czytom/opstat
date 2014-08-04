require 'mongo_mapper'
mongo = YAML::load( File.open( File.expand_path( File.dirname(__FILE__) + '/mongo.yml' ) ) )
MongoMapper.connection = Mongo::Connection.new(mongo['hostname'])
MongoMapper.database = mongo['database']
