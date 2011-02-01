class MapsController < ApplicationController
  def random
    @r = Geoname.skip(rand(Geoname.count)).first
    render :layout => 'network'
  end

  def query
    query = params[:query]
    country = params[:country]

    arr = Hash.new

    case query
    when 'ADM1'
      q = Geoname.only(:admin1, :name).where(:countrycode => country, :featurecode => query).order_by(:name.asc).all
      if q.nil? 
        q = []
      end
      q.each do |result|
        arr[result.admin1] = result.name
      end
    when 'ADM2'
      q = Geoname.where(:countrycode => country, :featurecode => query, :admin1 => params[:adm1]).order_by(:name.asc).all
      if q.nil? 
        q = []
      end
      q.each do |result|
        arr[result.admin2] = result.name
      end
    when 'ADM3'
      q = Geoname.where(:countrycode => country, :featurecode => query, :admin1 => params[:adm1], :admin2 => params[:adm2]).order_by(:name.asc).all
      if q.nil? 
        q = []
      end
      q.each do |result|
        arr[result.admin3] = result.name
      end
    when 'ADM4'
      q = Geoname.where(:countrycode => country, :featurecode => query, :admin1 => params[:adm1], :admin2 => params[:adm2], :admin3 => params[:adm3]).order_by(:name.asc).all
      if q.nil? 
        q = []
      end
      q.each do |result|
        arr[result.admin1] = result.name
      end
    end
    
    respond_to do |format|
      format.json { render :json => arr }
    end
  end
  
  def localization
    country = params[:country]
    query = params[:search]
    result = Geoname.search(query, country)
    
    respond_to do |format|
      format.json { render :json => result }
    end
  end
  
end
