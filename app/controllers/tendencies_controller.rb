class TendenciesController < ApplicationController
  def show
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @activities = @tendency.activities.where(:locale => session['locale']).order_by(:created_at.desc).limit(40)
      @title = "#{@tendency.name[session['locale']]}"
      render :layout => "tendencies" 
    end
  end

  def blogs
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @blogs = @tendency.connections_sort_by_time('BTend', 0, 40, 'DESC')
      @title = "#{@tendency.name[session['locale']]}"
      render :layout => 'tendencies'
    end
  end

  def members
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @members = @tendency.members
      @title = "#{@tendency.name[session['locale']]}"
      render :layout => 'tendencies'
    end
  end

  def groups
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @groups = @tendency.connections('GTend')
      @title = "#{@tendency.name[session['locale']]}"
      render :layout => 'tendencies'
    end
  end
end
