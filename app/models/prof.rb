class Prof < ActAsGraph
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tracking
  #include Sunspot::Mongoid
  include Mongoid::Search
  
  # Id of profile
  field :profilename
  index :profilename, :unique => true, :background => true
  field :locale
    
  track :visits        # Times its profile gets visited, records +1 when profile is visited the first time per session
  track :activities    # Number of activities for the given day
  
  embeds_many :albums
  embeds_many :statuses
  embeds_many :activities
  embeds_many :notifications
  
  has_many_related :blogs
  
  validates_format_of   :profilename, :with => /^[A-Za-z1-9]{3,30}$/
  validates_presence_of :profilename
  
  def add_visit
    self.visits.inc
  end
end
