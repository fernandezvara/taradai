class Activitydata
  include Mongoid::Document
  
  field :key,         :type => String
  field :data,        :type => String
  
  embedded_in :activity, :inverse_of => :activitydatas
  
end
