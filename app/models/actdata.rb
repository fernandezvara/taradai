class Actdata
  include Mongoid::Document
  
  field :key,         :type => String
  field :data,        :type => String
  
  embedded_in :act, :inverse_of => :actdata
  
end
