class SearchController < ApplicationController
  
  def form
    render :layout => 'none'
  end
  
  def results
    # if query is html....
    if params[:for].nil? == false and params[:search].nil? == false
      @for = params[:for]
      @search_terms = params[:search]
      session[:for] = @for
      session[:search_terms] = @search_terms
    else
      # if query is ajax.....
      if session[:for].nil? == false and session[:search_terms].nil? == false 
        @for = session[:for]
        @search_terms = session[:search_terms]
        puts '------------------------------------------------------------------paso'
      end
    end
        
    if @for == 'people' or @for == 'groups'
      if @search_terms.nil? == false
        case @for
        when 'people'
          @search = Profile.search(@search_terms).paginate(:per_page => 20, :page => params[:page])
        end
      end
    end
    
    @profile = @current_profile
    render :layout => 'profile'
  end
  
end
