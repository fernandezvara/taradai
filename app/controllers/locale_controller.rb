class LocaleController < ApplicationController
  def change
    if params[:locale].nil?
      redirect_to :root
    else
      locale = params[:locale]
      if locale == 'es' or locale == 'en'
        if user_signed_in?
          if @current_profile.nil? == false
            @current_profile.locale = locale
            @current_profile.save!
          end
        end
        session[:locale] = locale
        I18n.locale = locale
        flash[:success] = "Se ha cambiado el idioma correctamente."
        if request.env['HTTP_REFERER'].nil?
          redirect_to :root
        else
          redirect_to :back
        end
      else
        redirect_to :root
      end
    end
  end
end
