class BlogsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    # shows the blogs for the actual user, layout => my
    @blogs = @current_profile.connections_sort_by_time('Blog', 0, 0, 'DESC')
    render :layout => 'my'
  end
  
  def browse
    #shows the blogs for the given profile, shows the blogs the user can see, so if some blogs are private(just for the friends), will look if the @current_profile is friend
    @profile = Prof.where(:profilename => params[:profilename]).first
    if @profile.nil?
      redirect_to :root
    else
      @blogs = @profile.connections_sort_by_time('Blog', 0, 0, 'DESC')
      render :layout => 'profile'
    end
  end
  
  
  def show
    #show the blog with :slug and :profilename
    @profile = Prof.where(:profilename => params[:profilename]).first
    if @profile.nil?
      redirect_to :root
    else
      @blog = Blog.where(:slug => params[:slug], :prof_id => @profile.id.to_s).first
      if @blog.nil?
        redirect_to :root
      else
        @tendencies = @blog.connections('BTend')
        if @blog.privacy == true
          #check if the user is friend...
          if @profile.connected?('Friend', @current_profile) == true or @profile == @current_profile
            render :layout => 'profile'
          else
            redirect_to profile_show_url(:profilename => @profile.profilename)
          end
        else
          render :layout => 'profile'
        end
      end
    end
  end
  
  def new
    @blog = Blog.new
    @tendencies = Tendency.all
    render :layout => 'my'
  end
  
  def create
    if params[:blog].nil?
      redirect_to :root
    else
      @blog = Blog.new
      begin
        @blog.title = params[:blog][:title]
        @blog.body = params[:blog][:body]
        @blog.published = params[:blog][:published]
        @blog.privacy = params[:blog][:privacy]
        @blog.prof_id = @current_profile.id.to_s
      rescue
        flash[:error] = "Se ha encontrado un error al crear el blog, por favor vuelva a intentarlo."
        redirect_to :blog_new
      end
      if @blog.valid?
        if @blog.slugit! == true
          @blog.new_connection('Blog', @current_profile, true)
          activity = Hash.new
          activity['action'] = 'blog'
          activity['profile_id'] = @current_profile.id.to_s
          activity['blog_id'] = @blog.id.to_s
          new_activity(activity)
          tendencies = params[:t]
          tendencies.each do |key, value|
            if value == "1"
              #adds every tendency selected to the connections of the blog
              begin
                #relacionamos el blog con la tendencia
                @blog.new_connection('BTend', Tendency.find(key), true)
                # creamos la actividad en la tendencia
                new_tendency_activity(activity, key, session['locale'])
              rescue
              end
            end
          end
          flash[:success] = "Blog creado correctamente"
          redirect_to :blog_my
        else
          flash[:error] = "Se ha encontrado un error al crear el blog, por favor vuelva a intentarlo."
          render :action => 'new', :layout => 'my'
        end
      else
        flash[:error] = "Por favor, corrige los errores."
        render :action => 'new', :layout => 'my'
      end
    end
  end
  
  def edit
    @blog = Blog.find(:first, :conditions => { :prof_id => @current_profile.id.to_s, :slug => params[:slug] })
    if @blog.nil?
      redirect_to :blogs_show
    else
      @tendencies = Tendency.all
      render :layout => 'my' 
    end
  end
  
  def update
    @blog = Blog.where(:slug => params[:slug], :prof_id => @current_profile.id.to_s).first
    if @blog.nil?
      redirect_to :blog_my
    else
     if @blog.update_attributes(params[:blog]) == true
       @blog.slugit!
       #First, we delete all connections
       @tendencies = Tendency.all
       @tendencies.each do |t|
         t.delete_connection('BTend', @blog, true)
         puts "borrando..."
       end
       # Later we update them applying again
       tendencies = params[:t]
       tendencies.each do |key, value|
         if value == "1"
           #adds every tendency selected to the connections of the blog
           begin
             puts "aplicando... key = #{key}.... value=#{value}"
             @blog.new_connection('BTend', Tendency.find(key), true)
           rescue
           end
         end
       end
       redirect_to blog_read_url(:slug => @blog.slug)
      else
        render 'edit', :layout => 'my'
      end
    end
  end
  
  def read
    @blog = Blog.where(:slug => params[:slug], :prof_id => @current_profile.id.to_s).first
    if @blog.nil?
      redirect_to :blog_my
    else
      render :layout => 'my'
    end  
  end
  
  def delete
    @blog = Blog.where(:slug => params[:slug], :prof_id => @current_profile.id.to_s).first
    if @blog.nil?
      redirect_to :blog_my
    else
      render :layout => 'none'
    end  
  end
  
  def destroy
      @blog = Blog.where(:slug => params[:slug], :prof_id => @current_profile.id.to_s).first
      if @blog.nil?
        redirect_to :blog_my
      else
        @tendencies = @blog.connections('BTend')
        @tendencies.each do |t|
          t.delete_connection('BTend', @blog, true)
        end
        @blog.destroy
        redirect_to :back
      end  
    end
  
end
