class Ganswer
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :prof_id,    :type => String
  field :title,      :type => String
  field :body,       :type => String
  field :slug,       :type => String

  index :slug
  
  embedded_in :gtopic, :inverse_of => :ganswers
    
  def slugit!
    name = self.title
    if name == "new"
      name = "new1"
    end
    self.slug = find_unique_slug(name)
    if self.save!
      return true
    else
      return false
    end
  end
  
  private
  
  def find_unique_slug(subject, suffix = '')
    slug = ("#{subject} #{suffix}").parameterize
    if _parent.ganswers.where(:slug => slug).count == 0
      slug
    else
      if _parent.ganswers.where(:slug => slug).first == self
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
end
