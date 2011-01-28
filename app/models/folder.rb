class Folder
  include Mongoid::Document

  field :name, :type => String
  
  embeds_many :messages
  
  embedded_in :profile, :inverse_of => :inbox
  embedded_in :profile, :inverse_of => :outbox
end
