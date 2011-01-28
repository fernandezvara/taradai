class Group < ActAsGraph
  include Mongoid::Document

  field :name,          :type => String
  field :slug,          :type => String
  index :slug
  field :private,       :type => Boolean, :default => false
  field :description,   :type => String
  field :owner_id,      :type => String
  
  #mount_uploader :gportrait, GportraitUploader
  field :gportrait
  
  validates_length_of :name, :within => 4..50
  
  embeds_one :gforum
  
  embeds_many :activities
  
  def slugit!
    name = self.name
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
    if Group.where(:slug => slug).count == 0
      slug
    else
      if Group.where(:slug => slug).first == self
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
