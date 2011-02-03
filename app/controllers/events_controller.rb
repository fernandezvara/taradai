class EventsController < ApplicationController
  def my_events
    @title = "Mis eventos"
    render :layout => 'my'
  end

  def my_events_json
    start_time = params[:start]
    end_time = params[:end]
    #test = [{:id => '111', :title => 'test1', :start => Time.now.to_i, :end => Time.now.to_i + 7200, :allDay => false }, {:id => '112', :title => 'test2', :start => Time.now.to_i + 3600, :end => Time.now.to_i + 7200, :allDay => false },{:id => '113', :title => 'test5', :className => 'asdf', :start => Time.now.to_i + 5400, :end => Time.now.to_i + 14400, :allDay => false }]
    respond_to do |format|
      format.json { render :json => Event.my_events(@current_profile, start_time, end_time) }
    end
  end
  
  def my_events_create
    @event = Event.new(params[:event])
    #@event.title = params[:event][:title]
    #@event.description = params[:event][:description]
    #@event.start_time = (Date.)
    @event.obj_class = @current_profile.class.to_s
    @event.obj_id = @current_profile.id.to_s
    if @event.save
      redirect_to profile_my_events_url, :success => 'Evento creado correctamente'
    else
      flash.now[:error] = 'Por favor corrige los errores.'
      render :action => 'my_events_new', :layout => 'my'
    end
  end

  def my_events_new
    @event = Event.new
    @title = 'Nuevo Evento'
    render :layout => 'my'
  end

  def my_events_edit
  end

  def my_events_update
  end

  def my_events_delete
  end

  def my_events_destroy
  end

  def group_events
  end

  def group_events_new
  end

  def group_events_create
  end

  def group_events_edit
  end

  def group_events_update
  end

  def group_events_delete
  end

  def group_events_destroy
  end

  def tendency_events
  end

end
