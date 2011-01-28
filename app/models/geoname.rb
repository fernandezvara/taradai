class Geoname
  include Mongoid::Document
  
  field :name
  field :asciiname
  field :position,      :type => Array
  field :featurecode
  field :countrycode
  field :admin1
  field :admin2
  field :admin3
  field :admin4
  
  index :name, :unique => false
  index [[ :position, Mongo::GEO2D ]]
  index([[:countrycode, Mongo::ASCENDING],[:featurecode, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:featurecode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:featurecode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING],[:admin2, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:featurecode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING],[:admin2, Mongo::ASCENDING],[:admin3, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING],[:admin2, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING],[:admin2, Mongo::ASCENDING],[:admin3, Mongo::ASCENDING]], :unique => false)
end
