class Ev
 include Mongoid::Document
 include Mongoid::Timestamps
 include Mongoid::Slug

 field :title,            :type => String
 field :description,      :type => String

 field :start_time,       :type => DateTime
 field :end_time,         :type => DateTime
 field :full_day,         :type => Boolean,    :default => false
 field :privacy,          :type => Boolean,    :default => false
 field :location,         :type => String

 slug :title, :index => true

 index :start_time
 index :end_time

 validates_presence_of :title

 validates_datetime :end_time, :after => :start_time
 validates_datetime :start_time, :on => :create, :after => :now

end