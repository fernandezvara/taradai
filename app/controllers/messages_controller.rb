# coding: utf-8

class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def inbox
    @messages = @current_profile.inbox.messages
    @title = "Bandeja de Entrada"
    render :layout => 'my'
  end

  def read_inbox
    @message = @current_profile.inbox.messages.where(:slug => params[:slug]).first
    if @message.nil?
      redirect_to messages_inbox_url
    else
      @message.read!
      @title = @message.subject
      render :layout => 'my'
    end
  end

  def outbox
    @messages = @current_profile.outbox.messages
    @title = "Mensajes enviados"
    render :layout => 'my'
  end
  
  def read_outbox
    @message = @current_profile.outbox.messages.where(:slug => params[:slug]).first
    if @message.nil?
      redirect_to messages_outbox_url
    else
      @message.read!
      @title = @message.subject
      render :layout => 'my'
    end
  end

  def new
    @message = Message.new
    @title = 'Nuevo mensaje'
    render :layout => 'my'
  end

  def create
    message = Message.new
    to_string = params[:mail][:to]
    to_arr = to_string.split(',')
    
    temp_array = Array.new
    to_arr.each do |to|
      temp_array << to
    end
    
    message.to = temp_array
    message.from = @current_profile.id.to_s
    message.subject = params[:message][:subject]
    message.body = params[:message][:body]
    message.created_at = Time.now
    
    outbox = @current_profile.outbox
    message.readed = true
    outbox.messages << message
    message.slugit!
    outbox.save!
    message.save!
    
    temp_array.each do |to|
      inbox = Prof.find(to).inbox
      message_cloned = Message.new
      message_cloned.to = temp_array
      message_cloned.from = @current_profile.id.to_s
      message_cloned.subject = params[:message][:subject]
      message_cloned.body = params[:message][:body]
      message_cloned.created_at = Time.now
      inbox.messages << message_cloned
      message_cloned.slugit!
      inbox.save!
      message_cloned.save!
    end
    
    flash[:success] = "Mensaje enviado correctamente."
    redirect_to(messages_inbox_url)

  end

  def delete_inbox
    @message = @current_profile.inbox.messages.where(:slug => params[:slug]).first
    if @message.nil?
      redirect_to messages_inbox_url
    else
      render :layout => 'none'
    end
  end

  def destroy_inbox
    @message = @current_profile.inbox.messages.where(:slug => params[:slug]).first
    if @message.nil? == false
      @message.destroy
    end
    redirect_to messages_inbox_url
  end

  def delete_outbox
    @message = @current_profile.outbox.messages.where(:slug => params[:slug]).first
    if @message.nil?
      redirect_to messages_outbox_url
    else
      render :layout => 'none'
    end
  end

  def destroy_outbox
    @message = @current_profile.outbox.messages.where(:slug => params[:slug]).first
    if @message.nil? == false
      @message.destroy
    end
    redirect_to messages_outbox_url
  end


  def reply
    old_message = @current_profile.inbox.messages.where(:slug => params[:slug]).first
    to_arr = Array.new # array with the targets
    send = false
    if old_message.nil?
      redirect_to :root
    else
      old_sender = Prof.find(old_message.from)
      if old_sender.nil?
        old_name = "Usuario dado de baja"
      else
        to_arr << old_sender.id.to_s
        old_name = old_sender.name
        send = true
      end
      
      old_message.to.each do |old_to|
        if old_to != @current_profile.id.to_s
          to = Prof.find(old_to)
          if to.nil? == false
            to_arr << to.id.to_s
            send = true
          end
        end
      end
            
      @message = Message.new
      @message.subject = "Re: #{old_message.subject}"
      @message.body = "\n\r\n\r----- #{old_name} escribió: -----\n\r\n #{old_message.body}"
      
      if send == true
        js_text = "box"
        to_arr.each do |target| 
          temp_profile = Prof.find(target)
          js_text = js_text + ".add('#{temp_profile.name}', '#{temp_profile.id.to_s}')"
        end
        js_text = js_text + ";"
        @javascript_to = js_text
        @title = "Responder mensaje: #{old_message.subject}"
        render :layout => 'my'
      else
        flash[:error] = "No se puede enviar el mensaje, todos los usuarios han sido dados de baja."
        redirect_to messages_inbox_url
      end
    end
  end

end
