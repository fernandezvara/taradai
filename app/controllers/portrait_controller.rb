class PortraitController < ApplicationController
  def new
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    if @profile == @current_profile
      render :layout => 'none'
    else
      redirect_to profile_show_url(:profilename => @profile.profilename)
    end
  end

  def create
    if request.post?
      if params[:user].nil? or params[:Filedata].nil?
        redirect_to :root
      else
        if @current_profile.profilename == params[:user]
          if create_stalker_image_task(params[:Filedata], @current_profile.class.to_s, 'portrait', @current_profile.id.to_s, 'portrait')
          
          #@current_profile.portrait = params[:Filedata]
          #if @current_profile.save!
            activity = Hash.new
            activity['action'] = "portrait"
            activity['profile_id'] = @current_profile.id.to_s
            new_activity(activity)
            render :inline => "ok"
          else
            raise "Perfil no grabado"
          end
        else
          raise "error"
        end
      end
    else
      redirect_to :root
    end
  end

  def delete
  end

  def destroy
  end

end
