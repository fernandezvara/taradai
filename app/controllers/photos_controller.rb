# coding: utf-8

class PhotosController < ApplicationController
  
  before_filter :authenticate_user!
  
  def show
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    if @profile.nil?
      redirect_to profile_show_url(:profilename => params[:profilename])
    else
      @albums = @profile.albums
      @title = "Fotos"
      render :layout => 'profile'
    end
  end
  
  def album_show
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    if @profile.nil?
      redirect_to :root
    else
      @album = @profile.albums.where(:slug => params[:slug]).first
      if @album.nil?
        redirect_to photos_show_url(:profilename => @profile.profilename)
      else
        @photos = @album.photos.order_by(:order.asc).all
        @title = @album.title
        render :layout => 'profile'
      end
    end
  end
  
  def album_new
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    if @profile != @current_profile
      redirect_to :root
    else
      @album = Album.new
      render 'photos/album_new', :layout => 'none'
    end
  end
  
  def album_create
    if request.post?
      if params[:album].nil? or params[:album][:title].nil? or params[:album][:description].nil?
        redirect_to :root
      else
        album = Album.new
        title = params[:album][:title]
        if title == ""
          title = "Sin título"
        end
        album.title = title
        album.description = params[:album][:description]
        albums = @current_profile.albums
        albums << album
        album._parent.save!
        album.slugit!
        album.save!
        
        activity = Hash.new
        activity['action'] = "album"
        activity['album_id'] = album.id.to_s
        activity['profile_id'] = @current_profile.id.to_s
        new_activity(activity)
        
        redirect_to album_show_url(:slug => album.slug, :profilename => @current_profile.profilename)
      end
    else
      redirect_to :root
    end
  end
  
  def photo_show
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    if @profile.nil?
      redirect_to :root
    else
      @album = @profile.albums.where(:slug => params[:slug]).first
      if @album.nil?
        redirect_to photos_show_url(:profilename => @profile.profilename)
      else
        @photo = @album.photos.find(params[:id])
        if @photo.nil?
          redirect_to album_show_url(:profilename => @profile.profilename, :slug => @album.slug)
        else
          if @photo.order > 1
            @prev = @album.photos.where(:order => @photo.order - 1).first
          else
            @prev = false
          end
          if @photo.order != @album.photos.count
            @next = @album.photos.where(:order => @photo.order + 1).first
          else
            @next = false
          end
          render 'photos/photo_show', :layout => 'photo'
        end
      end
    end
  end
  
  def photo_new
    @profile = Profile.find(:first, :conditions => {:profilename => params[:profilename]})
    if @current_profile == @profile
      @album = @profile.albums.where(:slug => params[:slug]).first
      @photo = Photo.new
      render 'photos/photo_new', :layout => 'none'
    else
      redirect_to :root
    end
  end
  
  def photo_create
    if request.post?
      if params[:album].nil? or params[:user].nil? or params[:Filedata].nil?
        redirect_to :root
      else
        photo = Photo.new
        photo.title = ""
        photo.photo = params[:Filedata]
        album = @current_profile.albums.where(:slug => params[:album]).first
        if album.nil?
          redirect_to :root
        else
          album.photos << photo
          album.save!
          photo.order = album.photos.count
          photo.photo = "#{photo.id.to_s}.jpg"
          photo.save!
          create_stalker_image_task(params[:Filedata], photo.class.to_s, 'photo', photo.id.to_s, 'photo', @current_profile.id.to_s, album.slug)
          if album.photos.count == 1
            album.cover = photo.id.to_s
            album.save!
          end
          render :inline => 'ok'
        end
      end
    else
      redirect_to :root
    end
  end
  
  def album_organize
    @profile = Prof.where(:profilename => params[:profilename]).first
    if @profile != @current_profile
      redirect_to album_show_url(:profilename => params[:profilename], :slug => params[:slug])
    else
      @album = @profile.albums.where(:slug => params[:slug]).first
      @title = "Organización del album: #{@album.title}"
      @photos = @album.photos.order_by(:order.asc).all
      render :layout => 'profile'
    end
  end
  
  def album_org
    @profile = Prof.where(:profilename => params[:profilename]).first
    if @profile != @current_profile
      redirect_to album_show_url(:profilename => params[:profilename], :slug => params[:slug])
    else
      @album = @profile.albums.where(:slug => params[:slug]).first
      @photos = @album.photos
      keys = params[:photo].keys
      begin
        keys.each do |key|
          @photo = @photos.find(key.to_s)
          @photo.title = params[:photo][key][:title]
          @photo.order = params[:photo][key][:order]
          @photo.save!
        end
        flash[:success] = "Álbum actualizado correctamente"
        redirect_to album_show_url(:profilename => params[:profilename], :slug => params[:slug])
      rescue
        flash[:error] = "Ha ocurrido un error al actualizar el álbum, por favor, vuelva a intentarlo más tarde."
        redirect_to album_show_url(:profilename => params[:profilename], :slug => params[:slug])
      end
    end
  end
  
  def album_cover
    @album = @current_profile.albums.where(:slug => params[:slug]).first
    if @album.nil?
      redirect_to :root
    else
      @photo = @album.photos.find(params[:id])
      if @photo.nil?
        redirect_to :root
      else
        render :layout => 'none'
      end
    end
  end
  
  def album_newcover
    @album = @current_profile.albums.where(:slug => params[:slug]).first
    if @album.nil?
      redirect_to :root
    else
      @photo = @album.photos.find(params[:id])
      if @photo.nil?
        redirect_to :root
      else
        @album.cover = @photo.id.to_s
        if @album.save!
          flash[:success] = "Foto de portada cambiada correctamente."
          redirect_to album_show_url(:profilename => @current_profile.profilename, :slug => params[:slug])
        else
          flash[:error] = "No se ha podido cambiar la foto de portada, por favor, vuelva a intentarlo más tarde."
          redirect_to album_show_url(:profilename => @current_profile.profilename, :slug => params[:slug])
        end
      end
    end
  end
  
  def photo_delete
    @album = @current_profile.albums.where(:slug => params[:slug]).first
    if @album.nil?
      redirect_to :root
    else
      @photo = @album.photos.find(params[:id])
      if @photo.nil?
        redirect_to :root
      else
        render :layout => 'none'
      end
    end
  end
  
  def photo_deleteit
    @album = @current_profile.albums.where(:slug => params[:slug]).first
    if @album.nil?
      redirect_to :root
    else
      @photo = @album.photos.find(params[:id])
      if @photo.nil?
        redirect_to :root
      else
        order = @photo.order
        photo_id = @photo.id.to_s
        if @photo.delete
          @album.organize_photos!
          # if photo is the cover, we replace it with the first one on the album
          if @album.cover == photo_id
            if @album.photos.count == 0
              @album.cover = ""
            else
              @album.cover = @album.photos.first.id.to_s
            end
            @album.save!
          end
          flash[:success] = "Foto borrada correctamente."
          redirect_to album_show_url(:profilename => @current_profile.profilename, :slug => params[:slug])
        else
          flash[:error] = "No se ha podido borrar la foto, por favor, vuelva a intentarlo más tarde."
          redirect_to album_show_url(:profilename => @current_profile.profilename, :slug => params[:slug])
        end
      end
    end
  end
  
  def album_delete
    @album = @current_profile.albums.where(:slug => params[:slug]).first
    if @album.cover.nil? or @album.cover == ""
      @photo = false
    else
      @photo = @album.photos.find(@album.cover)
    end
    if @album.nil? or @photo.nil?
      redirect_to :root
    else
      render :layout => 'none'
    end
  end
  
  def album_deleteit
    @album = @current_profile.albums.where(:slug => params[:slug]).first
    if @album.nil?
      redirect_to :root
    else
      @album.photos.each do |photo|
        Stalker.enqueue('file.delete', :file => photo.photo, :type => 'photo')
      end
      if @album.destroy
        flash[:success] = "Albúm borrado correctamente."
        redirect_to photos_show_url(:profilename => @current_profile.profilename)
      else
        flash[:error] = "No se ha podido borrar el álbum de fotos, por favor, vuelva a intentarlo más tarde."
        redirect_to photos_show_url(:profilename => @current_profile.profilename)
      end
    end
  end
  
  
end
