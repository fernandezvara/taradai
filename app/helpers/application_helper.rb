# coding: utf-8

module ApplicationHelper
  def title
    if @title.nil?
      APP_CONFIG['app_title']
    else
      APP_CONFIG['app_title'] + " · " + @title
    end
  end
  
  def horoscope(date)
    day = date.day
    month = date.month
    
    case month
      when 1
        case day
          when 1..19
            horoscope = "capricornio"
          when 20..31
            horoscope = "acuario"
        end
      when 2
        case day
          when 1..17
            horoscope = "acuario"
          when 18..28
            horoscope = "piscis"
        end
      when 3
        case day
          when 1..19
            horoscope = "piscis"
          when 20..31
            horoscope = "aries"
        end
      when 4
        case day
          when 1..19
            horoscope = "aries"
          when 20..30
            horoscope = "tauro"
        end
      when 5
        case day
          when 1..20
            horoscope = "tauro"
          when 21..31
            horoscope = "geminis"
        end
      when 6
        case day
          when 1..20
            horoscope = "geminis"
          when 21..30
            horoscope = "cancer"
        end
      when 7
        case day
          when 1..22
            horoscope = "cancer"
          when 23..31
            horoscope = "leo"
        end
      when 8
        case day
          when 1..22
            horoscope = "leo"
          when 23..31
            horoscope = "virgo"
        end
      when 9
        case day
          when 1..22
            horoscope = "virgo"
          when 23..30
            horoscope = "libra"
        end
      when 10
        case day
          when 1..22
            horoscope = "libra"
          when 23..31
            horoscope = "escorpio"
        end
      when 11
        case day
          when 1..21
            horoscope = "escorpio"
          when 22..30
            horoscope = "sagitario"
        end
      when 12
        case day
          when 1..21
            horoscope = "sagitario"
          when 22..31
            horoscope = "capricornio"
        end
    end
    return horoscope
  end
  
  def file_path(value, type, style = '')
    # value = Object value to get info from
    # type = We need to pass the file type (portrait, gportrait, file, etc), so for images we need to put the default one if the value == nil
    # style = used on files for get the correct size one, if style = '' we won't append anything to the filename ''
    
    if value.nil? == false and value != ""
      bit = value.split("")[7].downcase
      case bit
      when "1", "2", "3", "4"
        server = APP_CONFIG['assets1']
      when "5", "6", "7", "8"
        server = APP_CONFIG['assets2']
      when "9", "0", "a", "b"
        server = APP_CONFIG['assets3']
      when "c", "d", "e", "f"
        server = APP_CONFIG['assets4']
      end
    end
    
    case type
    when 'file'
      if value.nil? or value == ""
        file = false
      else
        file = "#{server}#{value}"
      end
    when 'portrait'
      if value.nil? or value == ""
        file = "#{APP_CONFIG['assets']}images/portal/portrait/#{style}_default.jpg"
      else
        file = "#{server}#{style}_#{value}"
      end
    when 'gportrait'
      if value.nil? or value == ""
        file = "#{APP_CONFIG['assets']}images/portal/groups/#{style}_default.jpg"
      else
        file = "#{server}#{style}_#{value}"
      end
    when 'photo'
      if value.nil? or value == ""
        file = "#{APP_CONFIG['assets']}images/portal/albums/thumb.png"
      else
        file = "#{server}#{style}_#{value}"
      end
    end
    return file
  end
  
  
end
