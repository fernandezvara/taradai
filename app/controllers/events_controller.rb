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
    @event.obj_class = @current_profile.class.to_s
    @event.obj_id = @current_profile.id.to_s
    if @event.save
      puts params[:rec][:bool]
      puts params[:rec][:bool].class
      puts params[:rec][:times]
      puts params[:rec][:times].class
      puts params[:rec][:schedule]
      puts params[:rec][:schedule].class
      
      
      if params[:rec][:bool] == "1"
        #recurrency...
        @event.recurrent = @event.id.to_s
        @event.save
        
        recurrent_times = params[:rec][:times].to_i   #times to repeat the event
        recurrent_schedule = params[:rec][:schedule].to_s  #Type of repetition, week, month, year
        new_event = Hash.new
        recurrent_times.times do |r|   # r defines the round, if round = 0 we clone @event, else we clone new_event[r - 1]
          #each repetition do....
          puts "pasoooo - #{r}"
          if r == 0
            attribs = @event.attributes.select { |a| %w(title description obj_class obj_id full_day allow_attendees privacy location place_private place_id recurrent).include? a  }
            # Copying the data from the first event
            new_event[r] = Event.new attribs
            new_event[r - 1] = @event  # patch: if we are working with the new_event[0] we use the new_event[-1] for get the data
          else
            # Copying data from the last event
            attribs = new_event[r - 1].attributes.select { |a| %w(title description obj_class obj_id full_day allow_attendees privacy location place_private place_id recurrent).include? a }
            new_event[r] = Event.new attribs
          end
          
          puts "ID nuevo= #{new_event[r].id.to_s}"
          puts "ID anterior= #{new_event[r - 1].id.to_s}"
          puts "Class nuevo= #{new_event[r].class.to_s}"
          puts "Class anterior= #{new_event[r - 1].class.to_s}"
          
          case recurrent_schedule
          when "w"
            new_event[r].start_time = new_event[r - 1].start_time + 7.days
            new_event[r].end_time = new_event[r - 1].end_time + 7.days
          when "m"
            puts "paso mes - #{r}"
            starttime = new_event[r - 1].start_time.utc
            endtime = new_event[r - 1].end_time.utc
            if starttime.day > 28
              if starttime.next_month.end_of_month.day < starttime.day     # Si el último día del més que viene es inferior al día de hoy
                new_event[r].start_time = DateTime.new(starttime.next_month.year, starttime.next_month.month, starttime.next_month.end_of_month.day, starttime.hour, starttime.min)
              else
                new_event[r].start_time = starttime + 1.month   #Si el último día del més que viene es superior mantenemos el día y sumamos un més
              end
            end
            if endtime.day > 28
              if endtime.next_month.end_of_month.day < endtime.day     # Si el último día del més que viene es inferior al día de hoy
                new_event[r].end_time = DateTime.new(endtime.next_month.year, endtime.next_month.month, endtime.next_month.end_of_month.day, endtime.hour, endtime.min)
              else
                new_event[r].end_time = endtime + 1.month   #Si el último día del més que viene es superior mantenemos el día y sumamos un més
              end
            end
          when "y"
            new_event[r].start_time = new_event[r - 1].start_time + 1.year
            new_event[r].end_time = new_event[r - 1].end_time + 1.year
          end
          puts "fechas:"
          puts "start_time anterior  = #{new_event[r - 1].start_time}"
          puts "start_time posterior = #{new_event[r].start_time}"
          puts "end_time anterior  = #{new_event[r - 1].end_time}"
          puts "end_time posterior = #{new_event[r].end_time}"
          new_event[r].save!
        end
      end
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
