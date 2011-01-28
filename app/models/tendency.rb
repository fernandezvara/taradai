class Tendency < ActAsGraph
  include Mongoid::Document
  include Mongoid::Timestamps
  
  before_save create_forum!
  
  field :slug, :type => String
  index :slug
  field :name, :type => Hash
  
  embeds_many :activities
  embeds_one :gforum
  
  def members(limit = 0)
    tendencies = self.connections('Tend', limit)
    if tendencies.nil?
      tendencies = []
    end
    return tendencies
  end
  
  def members_count
    return self.connections_count('Tend')
  end
  
  def create_forum!
    self.create_gforum
  end
end
