# encoding: UTF-8
class PlacesprofController < ApplicationController
  
  before_filter :authenticate_user!
  
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
    @place = Privateplace.new
    @place.name = params[:privateplace][:name]
    @place.description = params[:privateplace][:description]
    @place.country = params[:privateplace][:country]
    @place.location = params[:privateplace][:location]
    @place.street = params[:privateplace][:street]
    @place.position = [params[:coords][:lat].to_i, params[:coords][:lng].to_i]
    @current_profile.privateplaces << @place
    if @place.save
      @flash_class = "success"
      @flash_message = "Centro creado correctamente."
    else
      @flash_class = "error"
      @flash_message = "Ha ocurrido un error al grabar el centro. Por favor, vuelve a intentarlo más tarde."
    end
    
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end

  def updatemap
    @id = params[:id]
  end

  def searchmap
    @id = params[:id]
    @search = params[:search]
    @error = false
    
    begin
      search = Geokit::Geocoders::GoogleGeocoder.geocode("#{Geoname.complete_text(@id)}, #{@search}".parameterize.gsub("-", " "))
      puts "Geokit::Geocoders::GoogleGeocoder.geocode(#{Geoname.complete_text(@id)}, #{@search})"
      @lat = search.lat
      @lng = search.lng
    rescue
      @error = true
    end
  end

end
