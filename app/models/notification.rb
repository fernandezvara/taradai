class Notification
  include Mongoid::Document
  
  field :action,       :type => String
  field :created_at,   :type => DateTime
  
  index :created_at
  
  embedded_in :prof, :inverse_of => :notifications
  
  embeds_many :notificationdatas
  
end
