class NotificationsController < ApplicationController
  
  def preview
    @notifications = @current_profile.notifications
    render :layout => 'none'
  end
  
  def index
    @notifications = @current_profile.notifications
    render :layout => 'my'
  end
end
