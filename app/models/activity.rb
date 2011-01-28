class Activity
  include Mongoid::Document
  
  field :action,       :type => String
  field :created_at,   :type => DateTime
  field :owner,        :type => Boolean
  field :locale,       :type => String
  
  index :created_at
  index :locale
  
  embedded_in :prof, :inverse_of => :activities
  embedded_in :group, :inverse_of => :activities
  embedded_in :tendency, :inverse_of => :activities
  
  embeds_many :activitydatas
  
end
