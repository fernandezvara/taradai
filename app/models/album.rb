class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title,        :type => String
  field :cover,        :type => String
  field :description,  :type => String
  field :slug,         :type => String
  index :slug
  
  embeds_many :photos
  
  validates_presence_of :title
  
  embedded_in :prof, :inverse_of => :albums
  
  def slugit!
    title = self.title
    if title == "new"
      title = "new1"
    end
    self.slug = find_unique_slug(title)
    self.save!
  end
  
  def organize_photos!
    photos = self.photos.only(:order).order_by(:order).all
    order = 1
    photos.each do |photo|
      photo.order = order
      photo.save!
      order = order + 1
    end
    pcover = self.photos.find(self.cover)
    if pcover.nil?
      if self.photos.count == 0
        self.cover = ""
      else
        self.cover = self.photos.first.id.to_s
      end
      self.save!
    end
  end
  
  private
  
  def find_unique_slug(subject, suffix = '')
    slug = ("#{subject} #{suffix}").parameterize
    if _parent.albums.where(:slug => slug).count == 0
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
