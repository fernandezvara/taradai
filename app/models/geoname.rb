class Geoname
  include Mongoid::Document
  
  field :name
  field :asciiname
  field :position,      :type => Array
  field :featurecode
  field :countrycode
  field :admin1
  field :admin2
  field :admin3
  field :admin4
  
  index :name, :unique => false
  index [[ :position, Mongo::GEO2D ]]
  index([[:countrycode, Mongo::ASCENDING],[:featurecode, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:featurecode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:featurecode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING],[:admin2, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:featurecode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING],[:admin2, Mongo::ASCENDING],[:admin3, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING],[:admin2, Mongo::ASCENDING]], :unique => false)
  index([[:countrycode, Mongo::ASCENDING],[:admin1, Mongo::ASCENDING],[:admin2, Mongo::ASCENDING],[:admin3, Mongo::ASCENDING]], :unique => false)
  
  def self.complete_text(id)
    temp = self.find(id)
    if temp.nil? 
      text = ""
    else
      if temp.admin4 == '' and temp.admin3 == '' and temp.admin2 == '' and temp.admin1 != ''
        text = temp.asciiname
      else
        if temp.admin4 == '' and temp.admin3 == '' and temp.admin2 != '' and temp.admin1 != ''
          text = self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => '', :admin3 => '', :admin4 => '').first.asciiname
          text = text + " - " + temp.asciiname
        else
          if temp.admin4 == '' and temp.admin3 != '' and temp.admin2 != '' and temp.admin1 != ''
            text = self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => '', :admin3 => '', :admin4 => '').first.asciiname
            text = text + " - " + self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => temp.admin2, :admin3 => '', :admin4 => '').first.asciiname
            text = text + " - " + temp.asciiname
          else
            if temp.admin4 != '' and temp.admin3 != '' and temp.admin2 != '' and temp.admin1 != ''
              text = self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => '', :admin3 => '', :admin4 => '').first.asciiname
              text = text + " - " + self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => temp.admin2, :admin3 => '', :admin4 => '').first.asciiname
              text = text + " - " + self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => temp.admin2, :admin3 => temp.admin3, :admin4 => '').first.asciiname
              text = text + " - " + temp.asciiname
            else
              text = ""
            end
          end
        end
      end
    end
    
    return text
  end
  
  def self.complete_text_accents(id)
    temp = self.find(id)
    if temp.nil? 
      text = ""
    else
      if temp.admin4 == '' and temp.admin3 == '' and temp.admin2 == '' and temp.admin1 != ''
        text = temp.name
      else
        if temp.admin4 == '' and temp.admin3 == '' and temp.admin2 != '' and temp.admin1 != ''
          text = self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => '', :admin3 => '', :admin4 => '').first.name
          text = text + " - " + temp.name
        else
          if temp.admin4 == '' and temp.admin3 != '' and temp.admin2 != '' and temp.admin1 != ''
            text = self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => '', :admin3 => '', :admin4 => '').first.name
            text = text + " - " + self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => temp.admin2, :admin3 => '', :admin4 => '').first.name
            text = text + " - " + temp.name
          else
            if temp.admin4 != '' and temp.admin3 != '' and temp.admin2 != '' and temp.admin1 != ''
              text = self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => '', :admin3 => '', :admin4 => '').first.name
              text = text + " - " + self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => temp.admin2, :admin3 => '', :admin4 => '').first.name
              text = text + " - " + self.where(:countrycode => temp.countrycode, :admin1 => temp.admin1, :admin2 => temp.admin2, :admin3 => temp.admin3, :admin4 => '').first.name
              text = text + " - " + temp.name
            else
              text = ""
            end
          end
        end
      end
    end
    
    return text
  end
  
  
  def self.search(query, country, max = 10)
    results = Array.new
    
    regex = "/#{query}/i"

    my_search = self.where(:countrycode => country, :name => eval(regex)).limit(max)
    #my_search = self.where(:countrycode => country)
    my_search.each do |s|
      results << ["#{s.id.to_s}", complete_text_accents("#{s.id.to_s}"),'', complete_text_accents("#{s.id.to_s}")]
    end
    
    puts "HE ENCONTRADO: #{my_search.count}"
    return results
      
  end
  
end
