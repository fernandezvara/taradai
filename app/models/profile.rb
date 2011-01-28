# coding: utf-8

class Profile < Prof

  after_save :create_mail_folders!

  before_destroy :delete_graphs, :delete_blogs

  # Basic Information
  field :first_name,        :type => String
  field :last_name,         :type => String
  field :last_name_show,    :type => Boolean,    :default => true
  field :gender,            :type => Boolean,    :default => false                           # 1 => hombre , 0 => mujer
  field :gender_show,       :type => Boolean,    :default => true
  field :country,           :type => String
  #field :state,             :type => String
  #field :province,          :type => String
  field :religion,          :type => String
  field :religion_show,     :type => Boolean,    :default => false
  field :civil_state,       :type => Integer,    :default => 0
  field :birthday,          :type => Date
  field :birthday_show,     :type => Integer,    :default => 0
  field :horoscope_show,    :type => Boolean,    :default => true
  
  # Long information
  field :about_me
  field :own_definition
  field :searching_for
  
  #mount_uploader :portrait, PortraitUploader
  
  field :portrait
  
  validates_presence_of :first_name, :last_name  #, :country
  validates_format_of   :first_name, :with => /^[A-Za-záéíóúäëïöüàèìòùâêîôû' ]{2,50}$/
  validates_format_of   :last_name, :with => /^[A-Za-záéíóúäëïöüàèìòùâêîôû' ]{2,50}$/
  
  referenced_in :user
  
  embeds_one :inbox, :class_name => 'Folder'
  embeds_one :outbox, :class_name => 'Folder'
  
  search_in :first_name, :last_name
  
  #searchable do
  #  text :first_name
  #  text :last_name
  #end
  
  
  def name
    if self.last_name_show == true 
      return self.first_name + " " + self.last_name
    else
      return self.first_name
    end
  end
  
  # Returns the profile objects that are friends of this profile
  def friends(limit = 0)
    friends = self.connections('Friend', limit)
    if friends.nil?
      friends = []
    end
    return friends
  end
  
  # Returns the number of profile objects linked to this profile
  def friends_count
    self.connections_count('Friend')
  end  
  
  def tendencies(limit = 0)
    tendencies = self.connections('Tend', limit)
    if tendencies.nil?
      tendencies = []
    end
    return tendencies
  end
  
  def tendencies_count
    self.connections_count('Tend')
  end
  
  def friends_autocomplete_list
    list = Array.new
    @friends = self.friends(0)
    @friends.each do |f|
      list << [f.id.to_s, f.name, nil,'<img src="/images/portal/avatars/avatar30.png" />'+ f.name]
    end
    return list
  end
    
  private
  
  def create_mail_folders!
    if self.inbox.nil?
      inbox = Folder.new
      inbox.name = "inbox"
      self.inbox = inbox
      self.save
    end
    if self.outbox.nil?
      outbox = Folder.new
      outbox.name = "outbox"
      self.outbox = outbox
      self.save
    end
  end
  
  def delete_graphs
    friends = self.connections('Friend')
    friends.each do |friend|
      puts "borrando conexión con #{friend.name} ..."
      self.delete_connection('Friend', friend, true)
    end
    tendencies = self.connections('Tend')
    tendencies.each do |tendency|
      puts "borrando conexión con #{tendency.slug} ..."
      self.delete_connection('Tend', tendency, true)
    end
  end
  
  def delete_blogs
    blogs = Blog.where(:prof_id => self.id.to_s)
    blogs.each do |blog|
      blog.destroy
    end
  end
  
end
