class PlacesprofController < ApplicationController
  
  def selection
    render :layout => 'none'
  end
  
  def index
    @places = @current_profile.privateplaces.enabled
    render :layout => 'none'
  end

  def new
    @place = @current_profile.privateplaces.new
    render :layout => 'none'
  end

  def create
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end

end
