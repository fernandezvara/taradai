# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  storage :file
  
  process :auto_orient
  process :resize_to_fit => [720, 640]
  process :convert => 'jpg'
  

  version :thumb do
    process :auto_orient
    process :resize_to_fill => [160,106]
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
      "/mnt/fs/a1/photo/#{prepend12}/#{prepend34}/#{prepend56}"
    when "2", "6", "0", "d"
      "/mnt/fs/a2/photo/#{prepend12}/#{prepend34}/#{prepend56}"
    when "3", "7", "a", "e"
      "/mnt/fs/a3/photo/#{prepend12}/#{prepend34}/#{prepend56}"
    when "4", "8", "b", "f"
      "/mnt/fs/a4/photo/#{prepend12}/#{prepend34}/#{prepend56}"
    end
  end

  # Override the filename of the uploaded files:
  def filename
    return "#{model.id.to_s}.jpg"
  end

  def url_path
    prepend1 = model.id.to_s.split('')[8].to_s
    prepend12 = "#{model.id.to_s.split('')[0].to_s}#{model.id.to_s.split('')[1].to_s}#{model.id.to_s.split('')[2].to_s}"
    prepend34 = "#{model.id.to_s.split('')[3].to_s}#{model.id.to_s.split('')[4].to_s}#{model.id.to_s.split('')[5].to_s}"
    prepend56 = "#{model.id.to_s.split('')[6].to_s}#{model.id.to_s.split('')[7].to_s}#{model.id.to_s.split('')[8].to_s}"
    
    case prepend1
    when "1", "5", "9", "c"
      "http://assets1.taradai.com/photo/#{prepend12}/#{prepend34}/#{prepend56}/"
    when "2", "6", "0", "d"
      "http://assets2.taradai.com/photo/#{prepend12}/#{prepend34}/#{prepend56}/"
    when "3", "7", "a", "e"
      "http://assets3.taradai.com/photo/#{prepend12}/#{prepend34}/#{prepend56}/"
    when "4", "8", "b", "f"
      "http://assets4.taradai.com/photo/#{prepend12}/#{prepend34}/#{prepend56}/"
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
