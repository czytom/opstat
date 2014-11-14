require 'mongo_mapper'
mongo = Opstat::Config.instance.get_mongo_config
MongoMapper.connection = Mongo::Connection.new(mongo['hostname'])
MongoMapper.database = mongo['database']
