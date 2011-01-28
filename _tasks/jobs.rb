require File.expand_path("/Users/antonio/Desktop/rails/taradai/config/environment", __FILE__)
require 'mogilefs'

include Stalker

job 'file.store' do |args|
  type = args['type']
  file = args['file']
  id = args['id']
  class_name = args['class_name']
  attr_name = args['attr_name']
  
  if type == 'photo'
    profile_id = args['prof_id'] 
    album_slug = args['album_slug']
    profile = Prof.find(profile_id)
    album = profile.albums.where(:slug => album_slug).first
    obj = album.photos.find(id)
  else
    obj = class_name.to_class.find(id)
  end
  
  if obj.nil? == false
  
    mogilefs = MogileFS::MogileFS.new(:domain => APP_CONFIG['mogile_domain'], :hosts => APP_CONFIG['mogile_trackers'])
  
    case type
    when 'portrait'
      img = Magick::Image.read(file).first
  
      img = img.auto_orient # flips if neccessary
      img.strip!
    
      img.crop_resized!(180,180, Magick::CenterGravity)
      mogilefs.store_content "a_#{obj.id.to_s}.jpg", 'text', img.to_blob
        
      img.crop_resized!(50,50, Magick::CenterGravity)
      mogilefs.store_content "50_#{obj.id.to_s}.jpg", 'text', img.to_blob
      
      img.crop_resized!(30,30, Magick::CenterGravity)
      mogilefs.store_content "30_#{obj.id.to_s}.jpg", 'text', img.to_blob
      
      obj.write_attribute("#{attr_name}", "#{obj.id.to_s}.jpg")
      obj.save
      
      #File.delete(file)
    when 'photo'

      img = Magick::Image.read(file).first
  
      img = img.auto_orient # flips if neccessary
      img.strip!
      
      img.resize_to_fit!(720,640)
      mogilefs.store_content "a_#{obj.id.to_s}.jpg", 'text', img.to_blob
        
      img.resize_to_fill!(160,106)
      mogilefs.store_content "t_#{obj.id.to_s}.jpg", 'text', img.to_blob
      
      obj.write_attribute("#{attr_name}", "#{obj.id.to_s}.jpg")
      obj.save
      
      #File.delete(file)
    end
  end # if obj.nil? == false
end
  
job 'file.delete' do |args|
  type = args['type']
  file = args['file']

  mogilefs = MogileFS::MogileFS.new(:domain => APP_CONFIG['mogile_domain'], :hosts => APP_CONFIG['mogile_trackers'])

  case type
  when 'photo'
    mogilefs.delete "t_#{file}"
    mogilefs.delete "a_#{file}"    
  when 'portrait'
    mogilefs.delete "a_#{file}"
    mogilefs.delete "50_#{file}"
    mogilefs.delete "30_#{file}"
  end
end

job 'activity.new' do |args|
  data = args['data']
  
  case data["action"]
  when "join"
    notify_to = Prof.find(data['profile_id']).connections('Friend')
    if notify_to.include?(Prof.find(data['profile_id'])) == false
      notify_to << Prof.find(data['profile_id'])
    end  
    owner_id = [data['profile_id']]
    # for each action defines the next action to make, send a mail, write a notification, etc
  when "friendship"
    notify_to = Prof.find(data['profile_id1']).connections('Friend')
    notify_to = notify_to | Prof.find(data['profile_id2']).connections('Friend')
    if notify_to.include?(Prof.find(data['profile_id1'])) == false
      notify_to << Prof.find(data['profile_id1'])
    end  
    if notify_to.include?(Prof.find(data['profile_id2'])) == false
      notify_to << Prof.find(data['profile_id2'])
    end  
    owner_id = [data['profile_id1'],data['profile_id2']]
  when "album"
    notify_to = Prof.find(data['profile_id']).connections('Friend')
    if notify_to.include?(Prof.find(data['profile_id'])) == false
      notify_to << Prof.find(data['profile_id'])
    end  
    owner_id = [data['profile_id']]
  when "portrait"
    notify_to = Prof.find(data['profile_id']).connections('Friend')
    if notify_to.include?(Prof.find(data['profile_id'])) == false
      notify_to << Prof.find(data['profile_id'])
    end  
    owner_id = [data['profile_id']]
  when "status"
    notify_to = Prof.find(data['profile_id']).connections('Friend')
    if notify_to.include?(Prof.find(data['profile_id'])) == false
      notify_to << Prof.find(data['profile_id'])
    end  
    owner_id = [data['profile_id']]
  when "blog"
    notify_to = Prof.find(data['profile_id']).connections('Friend')
    if notify_to.include?(Prof.find(data['profile_id'])) == false
      notify_to << Prof.find(data['profile_id'])
    end  
    owner_id = [data['profile_id']]
  when "group"
    notify_to = Prof.find(data['profile_id']).connections('Friend')
    if notify_to.include?(Prof.find(data['profile_id'])) == false
      notify_to << Prof.find(data['profile_id'])
    end
    owner_id = [data['profile_id']]
  when "joingroup"
    notify_to = Prof.find(data['profile_id']).connections('Friend')
    notify_to = notify_to | Group.find(data['group_id']).connections('GMember')
    if notify_to.include?(Prof.find(data['profile_id'])) == false
      notify_to << Prof.find(data['profile_id'])
    end  
    owner_id = [data['profile_id']]
  end

  notify_to.each do |prof|
    act = Activity.new
    act.action = data['action']
    act.created_at = Time.now
    if owner_id.include?(prof.id.to_s)
      act.owner = true
    end
    prof.activities << act
    
    if act.save
      data.each do |key, value|
        if key != "action"
          actdata = Activitydata.new
          actdata.key = key
          actdata.data = value
          act.activitydatas << actdata
          actdata.save
        end
      end
    end
    
    if prof.activities.count > 100
      activities_to_delete = prof.activities.order_by(:created_at.desc).skip(100).all
      activities_to_delete.each do |act|
        act.destroy
      end
    end
  end  
end

job 'activity.group.new' do |args|
  data = args['data']
  
  group = Group.find(data['group_id'])
  
  act = Activity.new
  act.action = data['action']
  act.created_at = Time.now
  group.activities << act
  
  if act.save
    data.each do |key, value|
      if key != "action"
        actdata = Activitydata.new
        actdata.key = key
        actdata.data = value
        act.activitydatas << actdata
        actdata.save
      end
    end
  end
  
  if group.activities.count > 100
    activities_to_delete = group.activities.order_by(:created_at.desc).skip(100).all
    activities_to_delete.each do |act|
      act.destroy
    end
  end
end

job 'activity.tendency.new' do |args|
  data = args['data']
  tendency_id = args['tendency']
  locale = args['locale']
  
  tendency = Tendency.find(tendency_id)
  
  act = Activity.new
  act.action = data['action']
  act.created_at = Time.now
  act.locale = locale
  tendency.activities << act
  
  if act.save
    data.each do |key, value|
      if key != "action"
        actdata = Activitydata.new
        actdata.key = key
        actdata.data = value
        act.activitydatas << actdata
        actdata.save
      end
    end
  end
  
  if tendency.activities.where(:locale => locale).count > 500
    activities_to_delete = tendency.activities.where(:locale => locale).order_by(:created_at.desc).skip(500).all
    activities_to_delete.each do |act|
      act.destroy
    end
  end
end


job 'notification.new' do |args|
  data = args['data']
  notify_to = Array.new
  
  case data['action']
  when 'friendship'
    notify_to << Prof.find(data['profile_id1']) # the one who sent the invitation
    # action = 'friendship'
    # profile_id1 = who sends the invitation
    # profile_id2 = who accepts the invitation
    #
  end
  
  notify_to.each do |prof|
    no = Notification.new
    no.action = data['action']
    no.created_at = Time.now
    prof.notifications << no
    
    if data['mail'] == true
      Stalker.enqueue "mail.send", :prof => prof.id.to_s, :data => data
      # send mail to the profile using the data
    end
    
    if no.save
      data.each do |key, value|
        if key != "action" and key != "mail"
          nodata = Activitydata.new
          nodata.key = key
          nodata.data = value
          no.notificationdatas << nodata
          nodata.save
        end
      end
    end
    
    if prof.notifications.count > 10
      notifications_to_delete = prof.notifications.order_by(:created_at.desc).skip(10).all
      notifications_to_delete.each do |no|
        no.destroy
      end
    end
  end
end

job 'mail.send' do |args|
  prof = args['prof']
  data = args['data']
  
  puts "Estoy corriendo en ENV = #{Rails.env}"
  
  NotificationMailer.send_mail(prof, data).deliver
    
end


#require 'rubygems'
#require 'mogilefs'
#hosts = %w[192.168.2.222:7001 192.168.2.221:7001]
#mg = MogileFS::MogileFS.new(:domain => 'tests', :hosts => hosts)
#i = 10000
#10000.times do
#mg.store_content i.to_s, 'text', "mi texto de prueba #{i.to_s}"
#i = i + 1
#puts i
#end

