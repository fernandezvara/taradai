# coding: utf-8

class GroupsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def new
    @group = Group.new
    @tendencies = Tendency.all
    render :layout => 'my'
  end
  
  def create
    @group = Group.new(params[:group])
    if @group.save
      @group.owner_id = @current_profile.id.to_s
      #@group.create_gforum
      @group.slugit!
      activity = Hash.new
      activity['action'] = 'group'
      activity['profile_id'] = @current_profile.id.to_s
      activity['group_id'] = @group.id.to_s
      new_activity(activity)
      new_group_activity(activity)
      tendencies = params[:t]
      tendencies.each do |key, value|
        if value == "1"
          #adds every tendency selected to the connections of the blog
          begin
            #relacionamos el grupo con la tendencia
            @group.new_connection('GTend', Tendency.find(key), true)
            # creamos la actividad en la tendencia
            new_tendency_activity(activity, key, session['locale'])
          rescue
          end
        end
      end
      # Creamos la conexión usuario -> grupo
      @group.new_connection('GMember', @current_profile, true)
      redirect_to groups_show_url
    else
      @tendencies = Tendency.all
      render :action => 'new', :layout => 'my'
    end
  end
  
  def show
    @group = Group.where(:slug => params[:slug]).first
    @title = @group.name
    @activities = @group.activities.order_by(:created_at.desc)
    #@activities = @group.connections_sort_by_time('GAct', 0, 40, 'DESC')
    render :layout => 'group'
  end
  
  def members
    @group = Group.where(:slug => params[:slug]).first
    if @current_profile.connected?('GMember', @group) == false and @group.private == true
      redirect_to group_show_url(:slug => @group.slug)
    else
      @title = @group.name
      @members = @group.connections('GMember')
      render :layout => 'group'
    end
  end
  
  def browse
    @groups = @current_profile.connections('GMember')
    @title = "Grupos"
    render :layout => 'my'
  end
  
  def edit
    @group = Group.where(:slug => params[:slug]).first
    @title = @group.name
    if @group.owner_id == @current_profile.id.to_s
      @tendencies = Tendency.all
      render :layout => 'my'
    else
      redirect_to :root
    end
  end
  
  def update
    @group = Group.where(:slug => params[:slug]).first
    @title = @group.name
    if @group.owner_id == @current_profile.id.to_s
      if @group.update_attributes(params[:group])
        @group.slugit!
        tend_temp = Tendency.all
        #deleting all connections
        tend_temp.each do |tend|
          tend.delete_connection('GTend', @group, true) if @group.connected?('GTend', tend)
        end
        #updating connections
        tendencies = params[:t]
        tendencies.each do |key, value|
          if value == "1"
            #adds every tendency selected to the connections of the blog
            begin
              #relacionamos el grupo con la tendencia
              @group.new_connection('GTend', Tendency.find(key), true)
              # creamos la actividad en la tendencia
              Tendency.find(key).new_connection('TAct', act, true)
            rescue
            end
          end
        end
        redirect_to group_show_url(:slug => @group.slug)
      else
        @tendencies = Tendency.all
        render :action => 'edit', :layout => 'my'
      end
    else
      redirect_to :root
    end
  end
  
  def delete
  end
  
  def destroy
  end             
  
  def apply
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      @gpending = Gpending.new
      render :layout => 'none'
    end
  end
  
  
  def applycreate
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      gpending = Gpending.new
      gpending.message = params[:gpending][:message]
      gpending.group_id = @group.id.to_s
      gpending.prof_id = @current_profile.id.to_s
      if gpending.save
        flash[:success] = "Tu petición de acceso al grupo se ha realizado correctamente."
        redirect_to group_show_url(:slug => @group.slug)
      else
        redirect_to :root
      end
    end
  end
  
  def join
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @group.private == true or @current_profile.connected?('GMember', @group)
        redirect_to group_show_url(:slug => @group.slug)
      else
        render :layout => 'none'
      end
    end
  end
  
  def joincreate
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @group.private == true
        redirect_to :root
      else
        activity = Hash.new
        activity['action'] = 'joingroup'
        activity['profile_id'] = @current_profile.id.to_s
        activity['group_id'] = @group.id.to_s
        new_activity(activity)
        new_group_activity(activity)
        # Añadimos al usuario al grupo
        @group.new_connection('GMember', @current_profile, true)
        flash[:success] = "Te has unido al grupo."
        redirect_to group_show_url(:slug => @group.slug)
      end
    end
    
  end
    
  def applies
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @group.owner_id == @current_profile.id.to_s
        @applies = Gpending.where(:group_id => @group.id.to_s)
        render :layout => 'group'
      else
        redirect_to :root
      end
    end
  end
  
  def accept 
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @group.owner_id == @current_profile.id.to_s
        pending = Gpending.where(:group_id => @group.id.to_s, :prof_id => params[:prof]).first
        if pending.nil?
          redirect_to :root
        else
          activity = Hash.new
          activity['action'] = 'joingroup'
          activity['profile_id'] = params[:prof]
          activity['group_id'] = @group.id.to_s
          new_activity(activity)
          new_group_activity(activity)
          # creamos la entrada en la actividad del grupo
          # @group.new_connection('GAct', act, true)
          # Añadimos al usuario al grupo
          profile = Prof.find(params[:prof])
          @group.new_connection('GMember', profile, true)
          pending.destroy
          flash[:success] = "Has añadido a #{profile.name} a este grupo."
          redirect_to group_applies_url(:slug => @group.slug)
        end
      else
        redirect_to :root
      end
    end
  end
  
  def ignore
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @group.owner_id == @current_profile.id.to_s
        pending = Gpending.where(:group_id => @group.id.to_s, :prof_id => params[:prof]).first
        if pending.nil?
          redirect_to :root
        else
          pending.destroy
          flash[:success] = "Has ignorado la petición como miembro."
          redirect_to group_applies_url(:slug => @group.slug)
        end
      else
        redirect_to :root
      end
    end
  end
    
  def profile_show
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    @title = @profile.name
    @groups = @profile.connections('GMember')
    render :layout => 'profile'
  end
  
  def portrait
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil? 
      redirect_to :root
    else
      if @group.owner_id == @current_profile.id.to_s
        render :layout => 'none'
      else
        redirect_to :root
      end
    end
  end
  
  def portrait_create
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil? 
      redirect_to :root
    else
      if @group.owner_id == @current_profile.id.to_s
        create_stalker_image_task(params[:Filedata], @group.class.to_s, 'portrait', @group.id.to_s, 'gportrait')
        if @group.save
          activity = Hash.new
          activity['action'] = "gportrait"
          activity['profile_id'] = @current_profile.id.to_s
          activity['group_id'] = @group.id.to_s
          new_group_activity(activity)
          flash[:success] = "Se ha cambiado la foto del grupo correctamente"
          render :inline => 'ok'
        else
          flash[:error] = "Se ha producido un error al cambiar la foto del grupo"
        end
      else
        redirect_to :root
      end
    end
  end
  
  
end
