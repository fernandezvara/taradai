# coding: utf-8

class StatusesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def new
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    if @profile.nil? or @profile != @current_profile
      redirect_to :root
    else
      @status = Status.new
      render :layout => 'none'
    end
  end

  def create
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    if @profile.nil? or @profile != @current_profile or params[:status].nil? or request.post? == false
      redirect_to :root
    else
      begin
        # if there is no status it breaks, so...
        if @current_profile.statuses.actual.status == params[:status][:status]
          same = true
        else
          same = false
        end
      rescue
        same = false
      end
        
      if same == false
        if @current_profile.statuses.create(:status => params[:status][:status])
          activity = Hash.new
          activity['action'] = "status"
          activity['profile_id'] = @current_profile.id.to_s
          activity['status_id'] = @current_profile.statuses.actual.id.to_s
          new_activity(activity)
      
          flash[:success] = "Tu estado se ha cambiado correctamente."
          redirect_to :back
        else
          flash[:error] = "No se ha podido cambiar tu estado, por favor, intentalo más tarde."
          redirect_to :back
        end
      else
        redirect_to :back
      end
    end
  end

end
