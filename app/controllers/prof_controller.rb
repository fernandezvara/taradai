class ProfController < ApplicationController
  
  before_filter :authenticate_user!
  
  def show
    @profile = Prof.find(:first, :conditions => {:profilename => params[:profilename]})
    
    @title = @profile.name
    @profile.add_visit
    
    case @profile.class.to_s
    when 'Profile'
      #nodes_temp = @profile.connections_nodes('Act')
      #if nodes_temp.count == 0
      #  @nodes = []
      #else
      #  temp_ids = Array.new
      #  nodes_temp.each do |act|
      #    temp_ids << act.split(':')[1]
      #  end
      #  @nodes = Act.criteria.id(temp_ids).order_by(:created_at.desc).limit(30)
      #end
      @nodes = @profile.activities.where(:owner => true).order_by(:created_at.desc)
      render 'profiles/show', :layout => 'profile'
    #when 'GroupProfile'
    end
  end
  
  def updates
    @profile = Prof.find(:first, :conditions => {:profilename => params[:profilename]})
    time = Time.at(params[:time].to_i)
    
    case @profile.class.to_s
    when 'Profile'
      #nodes_temp = @profile.connections_nodes('Act')
      #if nodes_temp.count == 0
      #  @nodes = []
      #else
      #  temp_ids = Array.new
      #  nodes_temp.each do |act|
      #    temp_ids << act.split(':')[1]
      #  end
      #  @nodes = Act.criteria.id(temp_ids).where(:created_at.gt => time).order_by(:created_at.desc)
      #end
      @nodes = @profile.activities.where(:owner => true, :created_at.gt => time).order_by(:created_at.desc)
    #when 'GroupProfile'
    end
  end
end
