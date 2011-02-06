# encoding: UTF-8
class ProfilesController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :update]
  
  def new
    @profile = Profile.new
    @tendencies = Tendency.all
    render 'profiles/new', :layout => 'auxpage'
  end

  def create
    @profile = Profile.new(params[:profile])
    @profile.user = current_user
    @profile.portrait = nil
    if @profile.save
      current_user.profile = @profile
      current_user.save!
      activity = Hash.new
      activity['action'] = 'join'
      activity['profile_id'] = @profile.id.to_s
      new_activity(activity)
      tendencies = params[:t]
      tendencies.each do |key, value|
        if value == "1"
          #adds every tendency selected to the connections of the profile
          begin
            @profile.new_connection('Tend', Tendency.find(key), true)
          rescue
          end
        end
      end
      redirect_to :root
    else
      @tendencies = Tendency.all
      render 'profiles/new', :layout => 'auxpage'
    end
  end

  def edit
    @profile = @current_profile
    if @profile.nil?
      redirect_to :root
    else
      render :layout => 'my'  
    end
  end

  def update
    if @current_profile.update_attributes(params[:profile])
      redirect_to profile_about_url(:profilename => @current_profile.profilename)
    else
      @profile = @current_profile
      render :action => 'edit'
    end
  end

  def show
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    @title = @profile.name
    render :layout => 'profile'
  end

  def index
  end

  def about
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    @title = @profile.name
    @tendencies = @profile.connections('Tend')
    render :layout => 'profile'
  end

end
