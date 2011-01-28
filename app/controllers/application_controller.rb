class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :current_profile
  before_filter :current_locale
  
  def new_activity(data)
    Stalker.enqueue('activity.new', :data => data)
  end
  
  def new_group_activity(data)
    Stalker.enqueue('activity.group.new', :data => data)
  end
  
  def new_tendency_activity(data, tendency_id, locale)
    Stalker.enqueue('activity.tendency.new', :data => data, :tendency => tendency_id, :locale => locale)
  end
  
  def new_notification(data)
    Stalker.enqueue('notification.new', :data => data)
  end
  
  def create_stalker_image_task(filedata, class_name, type, object_id, attr_name, prof_id = '', album_slug = '')
    filedata_name = ('a'..'z').sort_by {rand}[0,10].join + "_" + filedata.original_filename.gsub(" ", "_")
    path = File.join(APP_CONFIG['temporal_storage_photos_pre_queue'], filedata_name)
    File.open(path, "wb") do |f|
      f.write(filedata.read)
    end
    if type == 'photo'
      Stalker.enqueue("file.store", :type => type, :file => path, :class_name => class_name, :id => object_id, :attr_name => attr_name, :album_slug => album_slug, :prof_id => prof_id)
    else
      Stalker.enqueue("file.store", :type => type, :file => path, :class_name => class_name, :id => object_id, :attr_name => attr_name)
    end
  end
  
  private
  
  def current_profile
    if user_signed_in? == true
      if current_user.profile.nil? == false
        session[:current_profile] ||= current_user.profile.id.to_s
        begin
        @current_profile = Prof.find(session[:current_profile])
        rescue
          session[:current_profile] = current_user.profile.id.to_s
          @current_profile = Prof.find(session[:current_profile])
        end
      end
    else
      session.delete(:current_profile)
    end
  end
  
  def current_locale
    if session[:locale].nil? or session[:locale] == ""
      if user_signed_in?
        if @current_profile.nil? == false
          if @current_profile.locale.nil? or @current_profile.locale == ""
            locale = detect_locale
            @current_profile.locale = locale
            session[:locale] = locale
            I18n.locale = locale
          else
            session[:locale] = @current_profile.locale
            I18n.locale = locale
          end
        end
      else
        locale = detect_locale
        session[:locale] = locale
        I18n.locale = locale
      end
    end
  end
  
  def detect_locale
      langs = APP_CONFIG['languages']

      return I18n.default_locale if request.env["HTTP_ACCEPT_LANGUAGE"].nil?      # cannot detect language

      accepted = request.env["HTTP_ACCEPT_LANGUAGE"].split(/,/)   # comma-separated values, e.g. "ch,en,en-US"
      accepted = accepted.map { |l| l.strip.split(/\s*;\s*/) }    # each value have weight, e.g. "en-US;q=0.3"
      accepted = accepted.map do |l|
        [  l[0].split('-')[0].downcase.to_s,                      # each language can have dialect, e.g. "en-US"
           l.length == 1 ? 1.0 : l[1].sub(/^q=\s*/, '').to_f      # default q is "1.0" (if missing)
        ]
      end

      accepted = accepted.select {|l| l if langs.include?(l[0])}  # remove unsupported languages
      accepted.sort! { |l1, l2| l2[1] <=> l1[1] }                 # sort by quality (weight) descending
      return accepted.first[0]
    end
end
