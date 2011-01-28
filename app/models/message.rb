class Message
  include Mongoid::Document
      
  field :from,         :type => String
  field :to,           :type => Array
  field :subject,      :type => String
  field :body,         :type => String
  field :created_at,   :type => DateTime
  field :readed,       :type => Boolean,     :default => false
  # Not including Timestamps since the message won't be updatable after send.
  field :slug,         :type => String
  index :slug
    
  embedded_in :inbox, :inverse_of => :messages
  embedded_in :outbox, :inverse_of => :messages
  
  def read!
    self.readed = true
    self.save!
  end
  
  def slugit!
    self.slug = find_unique_slug(self.subject)
    self.save!
  end
  
  def find_unique_slug(subject, suffix = '')
    slug = ("#{subject} #{suffix}").parameterize
    if _parent.messages.where(:slug => slug).count == 0
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
