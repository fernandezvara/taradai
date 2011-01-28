require 'faker'

namespace :db do
  desc 'crea 100.000 usuarios'
  task :populate => :environment do
    a = Time.now
    10000.times do |n|
      if n % 100 == 0 
        puts n
      end
      profilename = ('a'..'z').to_a.shuffle[0..16].join
      email = "#{profilename}@taradai.com"
      profile = Profile.create!(:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :profilename => profilename)
      user = User.new
      user.email = email
      user.password = '123456'
      user.password_confirmation = '123456'
      user.profile = profile
      user.save!
      profile = nil
      user = nil
    end
    puts "#{(Time.now - a).to_i.to_s} segundos."
  end
  
  task :description => :environment do
    a = Time.now
    b = 0
    Profile.all.each do |p|
      p.about_me = Faker::Lorem.paragraphs(3)
      p.own_definition = Faker::Lorem.paragraphs(3)
      p.searching_for = Faker::Lorem.paragraphs(3)
      b = b + 1
      puts "#{b} -> #{p.name}"
      p.save
    end
    puts "#{(Time.now - a).to_i.to_s} segundos."
  end
  
  task :fake_friends => :environment do
    a = Time.now
    profiles_total = Profile.count.to_i
    existe = 0
    10000000.times do |n|
        if n % 100 == 0 
          puts n
        end
        node1 = Profile.find(:all, :skip => rand(profiles_total)).limit(1).first
        node2 = Profile.find(:all, :skip => rand(profiles_total)).limit(1).first
        
         if node1.new_connection('Friend', node2, true) == false
           existe = existe + 1
         end
    end
    puts "existían #{existe}"
    puts "#{(Time.now - a).to_i.to_s} segundos."
  end
  
  task :amigos_para_fernandezvara => :environment do 
    
    fernandezvara = Profile.where(:profilename => 'fernandezvara').first
    
    i = 1
    
    Prof.all.each do |profile|
      puts i
      fernandezvara.new_connection('Friend', profile, true)
      i = i +1
    end
    
    
  end
  
  
  task :activities => :environment do
    a = Time.now
    Profile.find(:all).each do |profile|
      data = Hash.new
      data["action"] = "join"
      data["profile_id"] = profile.id.to_s
      new_activity(data)
    end
    puts "#{(Time.now - a).to_i.to_s} segundos."
  end
  
  task :mailfolders => :environment do
    a = Time.now
    b = 0
    Profile.find(:all).each do |profile|
      b = b + 1
      puts b
      if profile.inbox.nil?
        inbox = Folder.new
        inbox.name = "inbox"
        profile.inbox = inbox
        profile.save
      end
      if profile.outbox.nil?
        outbox = Folder.new
        outbox.name = "outbox"
        profile.outbox = outbox
        profile.save
      end

    end
    puts "#{(Time.now - a).to_i.to_s} segundos."
  end
  
end