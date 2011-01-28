APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/app_config.yml")[Rails.env]

Graph.connect(:url => "redis://192.168.1.221:6379/0")

require 'mogilefs'

#Sunspot.session = Sunspot::Rails.build_session
#ActionController::Base.module_eval { include(Sunspot::Rails::RequestLifecycle) }

#Sunspot.config.solr.url = 'http://192.168.2.222:8080/solr'