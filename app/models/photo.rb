class Photo
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title
  field :order, :type => Integer
  
  #mount_uploader :photo, PhotoUploader
  field :photo
  
  embedded_in :album, :inverse_of => :photos
  
  
end
