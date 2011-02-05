class Privateplace
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name,            :type => String
  field :description,     :type => String
  field :country,         :type => String
  field :location,        :type => String
  field :street,          :type => String
  field :position,        :type => Array
  field :enabled,         :type => Boolean,     :default => true
  
  index [[ :position, Mongo::GEO2D ]]
  index [[:location], [:country]], :unique => false
  
  embedded_in :prof, :inverse_of => :privateplaces
  
  scope :enabled, where(:enabled => true) do
    def count
      size
    end
  end  
end
