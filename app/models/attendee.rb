class Attendee
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :prof_id,          :type => String
  field :status,           :type => Boolean   # 0 - no atenderé, 1 atenderé
    
  embedded_in :event, :inverse_of => :attendees
end
