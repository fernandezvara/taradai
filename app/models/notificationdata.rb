class Notificationdata
  include Mongoid::Document
  
  field :key,         :type => String
  field :data,        :type => String
  
  embedded_in :notification, :inverse_of => :notificationdatas
  
  
end
