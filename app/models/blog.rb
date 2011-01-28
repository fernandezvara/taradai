class Blog < ActAsGraph
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title
  field :body
  field :published,    :type => Boolean,      :default => false
  field :privacy,      :type => Boolean,      :default => false
  field :slug,         :type => String
  index :slug
  
  field :prof_id
  index :prof_id
  

  #referenced_in :profile
  
  validates_length_of :title, :minimum => 5, :maximum => 100
  validates_length_of :body, :minimum => 5, :maximum => 10000
  
  #embeds_many :blogcomments
  
  def slugit!
    title = self.title
    if title == "new"
      title = "new1"
    end
    self.slug = find_unique_slug(title)
    if self.save!
      return true
    else
      return false
    end
  end
  
  def published?
    published
  end
  
  private 
  
  def find_unique_slug(subject, suffix = '')
    slug = ("#{subject} #{suffix}").parameterize
    if Blog.where(:slug => slug).count == 0
      slug
    else
      if suffix == ''
        suffix = 1
      else
        suffix = suffix.to_i + 1
      end
      find_unique_slug(subject, suffix)
    end
  end
  
end
