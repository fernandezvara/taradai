class NetworkController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    if current_user.profile.nil?
      redirect_to new_profile_path
    else
      case @current_profile.class.to_s
      when 'Profile'
        @profile = @current_profile
      end
      
      @nodes = @current_profile.activities.order_by(:created_at.desc)
      render :layout => 'network'
    end
  end

  def updates
    if params[:time].nil? or @current_profile.nil?
      redirect_to :root
    else
      time = Time.at(params[:time].to_i)
      puts time
      case @current_profile.class.to_s
      when 'Profile'
        @profile = @current_profile
        @nodes = @current_profile.activities.where(:created_at.gt => time).order_by(:created_at.desc)
      end
    end
  end
end
