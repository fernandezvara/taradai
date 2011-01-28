class Tendency < ActAsGraph
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :slug, :type => String
  index :slug
  field :name, :type => Hash
  
  embeds_many :activities
  
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
end
