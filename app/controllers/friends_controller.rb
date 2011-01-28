class FriendsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def show
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    @title = @profile.name
    f = @profile.friends(0)
    @friends = f.sort_by { |a| a.name }
    render :layout => 'profile'
  end
  
  def req
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    @pending = Pending.new
    @pending.requester = @current_profile.id.to_s
    @pending.requested = @profile.id.to_s
    render :layout => 'none'
  end

  def list
    friends = @current_profile.friends_autocomplete_list
    callback = params[:callback]
    respond_to do |format|
      format.json { render :json => friends, :callback => callback }
    end 
  end

end
