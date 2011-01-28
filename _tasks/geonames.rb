require File.expand_path("/Users/antonio/Desktop/rails/taradai/config/environment", __FILE__)

file = File.open("geonames.txt", "r")

c = 0

file.each do |line|

  g = Geoname.new
  s = line.chomp.split("\t")
  c = c + 1
  if s[7] == "ADM1" or s[7] == "ADM2" or s[7] == "ADM3" or s[7] == "ADM4" 
    begin
      g.name = s[1]
      g.asciiname = s[2]
      g.position = [s[4].to_f, s[5].to_f]
      g.featurecode = s[7]
      g.countrycode = s[8]
      g.admin1 = s[10]
      g.admin2 = s[11]
      g.admin3 = s[12]
      g.admin4 = s[13]
      g.save!
      puts "(#{c}) Salvado  .... #{g.name} (#{g.id.to_s})"
    rescue
      puts "(#{c}) Error    .... #{g.name}"
    end
  else
    puts "(#{c}) Skipped    .... #{s[7]}"
  end
end
