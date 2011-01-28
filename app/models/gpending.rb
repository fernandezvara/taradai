class Gpending
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :group_id,     :type => String
  field :prof_id,      :type => String
  field :message,      :type => String
  
  index :group_id
  index :prof_id
end
