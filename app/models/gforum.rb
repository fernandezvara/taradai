class Gforum
  include Mongoid::Document
  
  embedded_in :group, :inverse_of => :gforum

  embeds_many :gtopics
end
