# encoding: utf-8

class GportraitUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  storage :file
  
  process :auto_orient
  process :resize_to_fill => [180, 180]
  process :convert => 'jpg'
  
  version :p50 do
    process :auto_orient
    process :resize_to_fill => [50,50]
    process :convert => 'jpg'
  end
  
  version :p30 do
    process :auto_orient
    process :resize_to_fill => [30,30]
    process :convert => 'jpg'
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    prepend1 = model.id.to_s.split('')[8].to_s
    prepend12 = "#{model.id.to_s.split('')[0].to_s}#{model.id.to_s.split('')[1].to_s}#{model.id.to_s.split('')[2].to_s}"
    prepend34 = "#{model.id.to_s.split('')[3].to_s}#{model.id.to_s.split('')[4].to_s}#{model.id.to_s.split('')[5].to_s}"
    prepend56 = "#{model.id.to_s.split('')[6].to_s}#{model.id.to_s.split('')[7].to_s}#{model.id.to_s.split('')[8].to_s}"
    
    case prepend1
    when "1", "5", "9", "c"
      "/mnt/fs/a1/gportrait/#{prepend12}/#{prepend34}/#{prepend56}"
    when "2", "6", "0", "d"
      "/mnt/fs/a2/gportrait/#{prepend12}/#{prepend34}/#{prepend56}"
    when "3", "7", "a", "e"
      "/mnt/fs/a3/gportrait/#{prepend12}/#{prepend34}/#{prepend56}"
    when "4", "8", "b", "f"
      "/mnt/fs/a4/gportrait/#{prepend12}/#{prepend34}/#{prepend56}"
    end
  end

  # Override the filename of the uploaded files:
  def filename
    if original_filename
      return "#{model.id.to_s}.jpg"
    else
      return model.gportrait_filename
    end
  end
  
  def default_url
   "/images/portal/groups/" + [version_name, "default.png"].compact.join('_')
  end

  def url
    if model.gportrait_filename.nil? == true or model.gportrait_filename == ""
      return "#{default_url}"
    else
      prepend1 = model.id.to_s.split('')[8].to_s
      prepend12 = "#{model.id.to_s.split('')[0].to_s}#{model.id.to_s.split('')[1].to_s}#{model.id.to_s.split('')[2].to_s}"
      prepend34 = "#{model.id.to_s.split('')[3].to_s}#{model.id.to_s.split('')[4].to_s}#{model.id.to_s.split('')[5].to_s}"
      prepend56 = "#{model.id.to_s.split('')[6].to_s}#{model.id.to_s.split('')[7].to_s}#{model.id.to_s.split('')[8].to_s}"
    
      case prepend1
      when "1", "5", "9", "c"
        "http://assets1.taradai.com/gportrait/#{prepend12}/#{prepend34}/#{prepend56}/" + [version_name, "#{filename}"].compact.join('_')
      when "2", "6", "0", "d"
        "http://assets2.taradai.com/gportrait/#{prepend12}/#{prepend34}/#{prepend56}/" + [version_name, "#{filename}"].compact.join('_')
      when "3", "7", "a", "e"
        "http://assets3.taradai.com/gportrait/#{prepend12}/#{prepend34}/#{prepend56}/" + [version_name, "#{filename}"].compact.join('_')
      when "4", "8", "b", "f"
        "http://assets4.taradai.com/gportrait/#{prepend12}/#{prepend34}/#{prepend56}/" + [version_name, "#{filename}"].compact.join('_')
      end
    end
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def auto_orient
    manipulate! do |img|
      img = img.auto_orient
    end
  end
end
