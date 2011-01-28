class Act < ActAsGraph
  include Mongoid::Document
  
  field :action,       :type => String
  field :created_at,   :type => DateTime
  
  index :created_at
  
  embeds_many :actdatas
  
end
