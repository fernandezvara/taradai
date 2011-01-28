# coding: utf-8

class GforumController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      @title = "#{@group.name} · Foro"
      @topics = @group.gforum.gtopics.order_by(:updated_at.desc)
      render :layout => 'forum'
    end
  end

  def topic
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
       @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
       if @topic.nil?
         flash[:error] = "No se ha encontrado el tema que buscabas. Es posible que haya sido borrado."
         redirect_to group_forum_url(:slug => @group.slug)
       else
         @answers = @topic.ganswers.order_by(:created_at.asc)
         @title = @topic.title
         render :layout => 'forum'
      end
    end
  end

  def new_topic
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil? 
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.new
        render :layout => 'none'
      else
        redirect_to :root
      end
    end
  end

  def create_topic
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil? or params[:gtopic].nil?
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.create(:prof_id => @current_profile.id.to_s, :title => params[:gtopic][:title], :body => params[:gtopic][:body])
        if @topic.save
          if @topic.title == ""
            @topic.title = "Sin asunto"
          end
          @topic.slugit!
          activity = Hash.new
          activity['action'] = "gforum"
          activity['profile_id'] = @current_profile.id.to_s
          activity['group_id'] = @group.id.to_s
          activity['topic_id'] = @topic.id.to_s
          new_group_activity(activity)
          #@group.new_connection('GAct', act, true) -> Thats the old way to assign activities, now we add the activity to the group.activities
          # TODO: it's necessary to implement an activities system for groups.
          flash[:success] = "Se ha enviado tu mensaje."
          redirect_to group_forum_topic_show_url(:slug => @group.slug, :tslug => @topic.slug)
        else
          flash[:error] = "No se ha podido enviar el mensaje debido a un error, por favor intentalo más tarde."
          redirect_to group_forum_url(:slug => @group.slug)
        end
      else
        redirect_to :root
      end
    end
  end

  def edit_topic
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
       @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
       if @topic.nil?
         redirect_to group_forum_url(:slug => @group.slug)
       else
         @title = @topic.title
         render :layout => 'none'
      end
    end
  end

  def update_topic
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil? or params[:gtopic].nil?
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
        if @topic.nil?
          redirect_to group_forum_url(:slug => @group.slug)
        else
          if @topic.update_attributes(params[:gtopic])
            if @topic.title == ""
              @topic.title = "Sin asunto"
            end
            @topic.slugit!
            flash[:success] = "Se ha editado correctamente tu mensaje."
            redirect_to group_forum_topic_show_url(:slug => @group.slug, :tslug => @topic.slug)
          else
            flash[:error] = "No se ha podido editar el mensaje debido a un error, por favor intentalo más tarde."
            redirect_to group_forum_url(:slug => @group.slug)
          end
        end
      else
        redirect_to :root
      end
    end
  end

  def delete_topic
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
        if @topic.nil?
          redirect_to group_forum_url(:slug => @group.slug)
        else
          render :layout => 'none'
        end
      else
        redirect_to :root
      end
    end
  end

  def destroy_topic
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
        if @topic.nil?
          redirect_to group_forum_url(:slug => @group.slug)
        else
          if @topic.destroy
            flash[:success] = "Mensaje borrado correctamente."
            redirect_to group_forum_url(:slug => @group.slug)
          else
            flash[:error] = "No se ha podido borrar el mensaje debido a un error, por favor intentalo más tarde."
            redirect_to group_forum_url(:slug => @group.slug)
          end
        end
      else
        redirect_to :root
      end
    end
  end

  def new_answer
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil? 
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
        if @topic.nil?
          redirect_to group_forum_url(:slug => @group.slug)
        else
          @answer = @topic.ganswers.new
          @answer.title = "Re: #{@topic.title}"
          render :layout => 'none'
        end
      else
        redirect_to :root
      end
    end
  end

  def create_answer
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil? or params[:ganswer].nil?
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
        if @topic.nil?
          redirect_to group_forum_url(:slug => @group.slug)
        else
          @answer = @topic.ganswers.create(:prof_id => @current_profile.id.to_s, :title => params[:ganswer][:title], :body => params[:ganswer][:body])
          if @answer.save
            if @answer.title == ""
              @answer.title = "Sin asunto"
            end
            @answer.slugit!
            @topic.save
            flash[:success] = "Se ha enviado tu respuesta."
            redirect_to group_forum_topic_show_url(:slug => @group.slug, :tslug => @topic.slug)
          else
            flash[:error] = "No se ha podido enviar el mensaje debido a un error, por favor intentalo más tarde."
            redirect_to group_forum_topic_show_url(:slug => @group.slug, :tslug => @topic.slug)
          end
        end
      end
    end
  end

  def edit_answer
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
        if @topic.nil?
          redirect_to group_forum_url(:slug => @group.slug)
        else
          @answer = @topic.ganswers.where(:slug => params[:aslug]).first
          if @answer.nil?
            redirect_to :root
          else
            render :layout => 'none'
          end
        end
      end
    end
  end

  def update_answer
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil? or params[:ganswer].nil?
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
        if @topic.nil?
          redirect_to group_forum_url(:slug => @group.slug)
        else
          @answer = @topic.ganswers.where(:slug => params[:aslug]).first
          if @answer.update_attributes(params[:ganswer])
            if @answer.title == ""
              @answer.title = "Sin asunto"
            end
            @answer.slugit!
            @topic.save
            flash[:success] = "Se ha editado correctamente tu respuesta."
            redirect_to group_forum_topic_show_url(:slug => @group.slug, :tslug => @topic.slug)
          else
            flash[:error] = "No se ha podido editar la respuesta debido a un error, por favor intentalo más tarde."
            redirect_to group_forum_url(:slug => @group.slug)
          end
        end
      else
        redirect_to :root
      end
    end
  end

  def delete_answer
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
        if @topic.nil?
          redirect_to group_forum_url(:slug => @group.slug)
        else
          @answer = @topic.ganswers.where(:slug => params[:aslug]).first
          if @answer.nil?
            flash[:error] = "No se ha encontrado la respuesta."
            redirect_to redirect_to group_forum_url(:slug => @group.slug)
          else
            render :layout => 'none'
          end
        end
      else
        redirect_to :root
      end
    end
  end

  def destroy_answer
    @group = Group.where(:slug => params[:slug]).first
    if @group.nil?
      redirect_to :root
    else
      if @current_profile.connected?('GMember', @group)
        @topic = @group.gforum.gtopics.where(:slug => params[:tslug]).first
        if @topic.nil?
          redirect_to group_forum_url(:slug => @group.slug)
        else
          @answer = @topic.ganswers.where(:slug => params[:aslug]).first
          if @answer.nil?
            flash[:error] = "No se ha encontrado la respuesta."
            redirect_to group_forum_topic_show_url(:slug => @group.slug, :tslug => @topic.slug)
          else
            if @answer.destroy
              flash[:success] = "Se ha borrado la respuesta al tema."
              redirect_to group_forum_topic_show_url(:slug => @group.slug, :tslug => @topic.slug)
            else
              flash[:error] = "Ha habido un error al intentar borrar la respuesta, intentalo más tarde."
              redirect_to group_forum_topic_show_url(:slug => @group.slug, :tslug => @topic.slug)
            end
          end
        end
      else
        redirect_to :root
      end
    end
  end
end
