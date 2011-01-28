# encoding: utf-8

class TforumController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @title = "#{@tendency.name[session['locale']]} · Foro"
      @topics = @tendency.gforum.gtopics.order_by(:updated_at.desc)
      render :layout => 'forum'
    end
  end

  def topic
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug]).first
      if @topic.nil?
        flash[:error] = "No se ha encontrado el tema que buscabas. Es posible que haya sido borrado."
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      else
        @answers = @topic.ganswers.order_by(:created_at.asc)
        @title = @topic.title
        render :layout => 'forum'
      end
    end
  end

  def new_topic
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil? 
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.new
      render :layout => 'none'
    end
  end

  def create_topic
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil? or params[:gtopic].nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.create(:prof_id => @current_profile.id.to_s, :title => params[:gtopic][:title], :body => params[:gtopic][:body])
      if @topic.save
        if @topic.title == ""
          @topic.title = "Sin asunto"
        end
        @topic.slugit!
        activity = Hash.new
        activity['action'] = "tforum"
        activity['profile_id'] = @current_profile.id.to_s
        activity['tendency_id'] = @tendency.id.to_s
        activity['topic_id'] = @topic.id.to_s
        new_activity(activity)
        new_tendency_activity(activity, @tendency.id.to_s, session['locale'])
        flash[:success] = "Se ha enviado tu mensaje."
        redirect_to tendencies_forum_topic_show_url(:name => @tendency.slug, :tslug => @topic.slug)
      else
        flash[:error] = "No se ha podido enviar el mensaje debido a un error, por favor intentalo más tarde."
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      end
    end
  end

  def edit_topic
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug]).first
      if @topic.nil?
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      else
        @title = @topic.title
        render :layout => 'none'
      end
    end
  end

  def update_topic
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil? or params[:gtopic].nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug]).first
      if @topic.nil?
        redirect_to tendency_forum_url(:name => @tendency.slug)
      else
        if @topic.update_attributes(params[:gtopic])
          if @topic.title == ""
            @topic.title = "Sin asunto"
          end
          @topic.slugit!
          flash[:success] = "Se ha editado correctamente tu mensaje."
          redirect_to tendencies_forum_topic_show_url(:name => @tendency.slug, :tslug => @topic.slug)
        else
          flash[:error] = "No se ha podido editar el mensaje debido a un error, por favor intentalo más tarde."
          redirect_to tendencies_forum_url(:name => @tendency.slug)
        end
      end
    end
  end

  def delete_topic
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug], :prof_id => @current_profile.id.to_s).first
      if @topic.nil?
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      else
        render :layout => 'none'
      end
    end
  end

  def destroy_topic
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug], :prof_id => @current_profile.id.to_s).first
      if @topic.nil?
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      else
        if @topic.destroy
          flash[:success] = "Mensaje borrado correctamente."
          redirect_to tendencies_forum_url(:name => @tendency.slug)
        else
          flash[:error] = "No se ha podido borrar el mensaje debido a un error, por favor intentalo más tarde."
          redirect_to tendencies_forum_url(:name => @tendency.slug)
        end
      end
    end
  end

  def new_answer
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil? 
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug]).first
      if @topic.nil?
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      else
        @answer = @topic.ganswers.new
        @answer.title = "Re: #{@topic.title}"
        render :layout => 'none'
      end
    end
  end

  def create_answer
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil? or params[:ganswer].nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug]).first
      if @topic.nil?
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      else
        @answer = @topic.ganswers.create(:prof_id => @current_profile.id.to_s, :title => params[:ganswer][:title], :body => params[:ganswer][:body])
        if @answer.save
          if @answer.title == ""
            @answer.title = "Sin asunto"
          end
          @answer.slugit!
          @topic.save
          flash[:success] = "Se ha enviado tu respuesta."
          redirect_to tendencies_forum_topic_show_url(:name => @tendency.slug, :tslug => @topic.slug)
        else
          flash[:error] = "No se ha podido enviar el mensaje debido a un error, por favor intentalo más tarde."
          redirect_to tendencies_forum_topic_show_url(:name => @tendency.slug, :tslug => @topic.slug)
        end
      end
    end
  end

  def edit_answer
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug], :prof_id => @current_profile.id.to_s).first
      if @topic.nil?
        redirect_to tendencies_forum_url(:name => @tendency.slug)
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

  def update_answer
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil? or params[:ganswer].nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug]).first
      if @topic.nil?
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      else
        @answer = @topic.ganswers.where(:slug => params[:aslug]).first
        if @answer.update_attributes(params[:ganswer])
          if @answer.title == ""
            @answer.title = "Sin asunto"
          end
          @answer.slugit!
          @topic.save
          flash[:success] = "Se ha editado correctamente tu respuesta."
          redirect_to tendencies_forum_topic_show_url(:name => @tendency.slug, :tslug => @topic.slug)
        else
          flash[:error] = "No se ha podido editar la respuesta debido a un error, por favor intentalo más tarde."
          redirect_to tendencies_forum_url(:name => @tendency.slug)
        end
      end
    end
  end

  def delete_answer
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug], :prof_id => @current_profile.id.to_s).first
      if @topic.nil?
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      else
        @answer = @topic.ganswers.where(:slug => params[:aslug]).first
        if @answer.nil?
          flash[:error] = "No se ha encontrado la respuesta."
          redirect_to redirect_to tendencies_forum_url(:name => @tendency.slug)
        else
          render :layout => 'none'
        end
      end
    end
  end

  def destroy_answer
    @tendency = Tendency.where(:slug => params[:name]).first
    if @tendency.nil?
      redirect_to :root
    else
      @topic = @tendency.gforum.gtopics.where(:slug => params[:tslug]).first
      if @topic.nil?
        redirect_to tendencies_forum_url(:name => @tendency.slug)
      else
        @answer = @topic.ganswers.where(:slug => params[:aslug]).first
        if @answer.nil?
          flash[:error] = "No se ha encontrado la respuesta."
          redirect_to tendencies_forum_topic_show_url(:name => @tendency.slug, :tslug => @topic.slug)
        else
          if @answer.destroy
            flash[:success] = "Se ha borrado la respuesta al tema."
            redirect_to tendencies_forum_topic_show_url(:name => @tendency.slug, :tslug => @topic.slug)
          else
            flash[:error] = "Ha habido un error al intentar borrar la respuesta, intentalo más tarde."
            redirect_to tendencies_forum_topic_show_url(:name => @tendency.slug, :tslug => @topic.slug)
          end
        end
      end
    end
  end
end