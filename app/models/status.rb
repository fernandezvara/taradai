class Status
  include Mongoid::Document
  include Mongoid::Timestamps
  
  after_create :delete_old
  
  field :status, :type => String
  
  embedded_in :prof, :inverse_of => :statuses
  
  def self.actual
    self.all.order_by(:created_at.desc).limit(1).first
  end
  
  private
  
  def delete_old
    count = _parent.statuses.count
    puts count
    if count > 10
      all = _parent.statuses.all.order_by(:created_at.desc)
      (10..count - 1).each do |index|
        puts "borrando... #{index.to_s}"
        all[index].destroy
      end
    end   
  end
  
end
