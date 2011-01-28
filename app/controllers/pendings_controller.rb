# coding: utf-8

class PendingsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @requests = Pending.find(:all, :conditions => { :requested => @current_profile.id.to_s })
    render :layout => 'my'
  end
  
  def requested
    @requests = Pending.find(:all, :conditions => { :requester => @current_profile.id.to_s })
    render :layout => 'my'
  end

  def new
  end

  def create
    if params[:pending][:requester] == @current_profile.id.to_s
      if Pending.create!(params[:pending])
        requested = Profile.find(params[:pending]['requested'])
        @flashcss = 'success'
        @flashmsg = "Se ha enviado correctamente tu petición como amigo a #{requested.name}."
      else
        @flashcss = 'error'
        @flashmsg = "Tu petición como amigo no se ha podido procesar, por favor intentalo más tarde."
      end
    else
      redirect_to :root
    end
  end

  def delete
  end

  def accept
    pending = Pending.find(params[:id])
    if pending.nil? 
      redirect_to :root
    else
      if pending.requested != @current_profile.id.to_s
        redirect_to :root
      else
        other_profile = Prof.find(pending.requester)
        if @current_profile.new_connection('Friend', other_profile, true) == true
          activity = Hash.new
          activity['action'] = 'friendship'
          activity['profile_id1'] = @current_profile.id.to_s
          activity['profile_id2'] = other_profile.id.to_s
          new_activity(activity)
          flash[:success] = "Has aceptado la petición como amigo de #{other_profile.name}."
          pending.destroy
          redirect_to friend_requests_url
        else
          flash[:error] = "La petición como amigo no se ha podido completar."
          redirect_to friend_requests_url
        end
      end
    end
  end
  
  def ignore
    pending = Pending.find(params[:id])
    if pending.nil? 
      redirect_to :root
    else
      if pending.requested != @current_profile.id.to_s
        redirect_to :root
      else
        other_profile = Prof.find(pending.requester)
        flash[:success] = "Has ignorado la petición como amigo de #{other_profile.name}."
        pending.destroy
        redirect_to friend_requests_url
      end
    end
  end

end
