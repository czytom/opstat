require 'mongoid'
mongo_config_file = Opstat::Config.instance.get_mongo_config_file_path
Mongoid.load!(mongo_config_file)
