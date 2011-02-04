class Event < ActAsGraph
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  
  field :title,            :type => String
  field :description,      :type => String
  field :obj_class,        :type => String   #owner class
  field :obj_id,           :type => String   #owner id
  field :start_time,       :type => DateTime
  field :end_time,         :type => DateTime
  field :full_day,         :type => Boolean,    :default => false
  field :allow_attendees,  :type => Boolean,    :default => false
  field :privacy,          :type => Boolean,    :default => false
  field :location,         :type => String
  field :birthday,         :type => Boolean,    :default => false
  field :attend,           :type => Boolean,    :default => false
  field :place_private,    :type => Boolean
  field :place_id,         :type => String
  
  slug :title, :index => true
  
  index [[:obj_class, Mongo::ASCENDING] , [:obj_id, Mongo::ASCENDING]], :unique => false
  index :allow_attendees
  index :privacy
  index :start_time
  index :end_time
  
  validates_presence_of :title
  #validates_presence_of :location unless privacy == true
  validates_datetime :end_time, :after => :start_time, :after_message => "debe ser superior a la fecha de comienzo"
  validates_datetime :start_time, :on => :create, :after => :now
  
  embeds_many :attendees
  
  def self.my_events(obj, start_time, end_time)
    events = self.where(:obj_class => obj.class.to_s, :obj_id => obj.id.to_s).and(:start_time.gt => Time.at(start_time.to_i), :start_time.lt => Time.at(end_time.to_i))
    arr = Array.new
    events.each do |event|
      #begin
        if event.place_id.nil? == false and event.place_id != ""
          if event.place_private == true
            center = obj.privateplaces.find(event.place_id)
            text = " (#{center.name})"
            #TODO: IT'S NECESARY TO ADD A SEARCHER FOR CENTERS NON-PRIVATES
          else 
            text = ""
          end
        else
          text = ""
        end
        if event.privacy == true

            arr << { :id => event.id.to_s, :title => event.title + text, :start => event.start_time.to_i, :end => event.end_time.to_i, :allDay => event.full_day, :className => "ev0" }
        else
          arr << { :id => event.id.to_s, :title => event.title + text, :start => event.start_time.to_i, :end => event.end_time.to_i, :allDay => event.full_day, :className => "ev1" }
        end
      #rescue
      #end
    end
    arr
  end

end
