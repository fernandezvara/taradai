class Pending
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :requester, :type => String
  index :requester, :unique => false
  field :requested, :type => String
  index :requested, :unique => false
  field :message
  
  attr_protected :_id

end
