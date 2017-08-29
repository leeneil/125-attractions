# encoding=utf-8 
require "open-uri"
require "json"
require "geocoder"
require "csv"


GEOCODE = true
file_path = "data/125-attractions.json"


cd = 0

geo_data = []
if GEOCODE
	file = File.read(file_path)
	data = JSON.parse(file)
	for att in data
		keyword = att["name"]
		puts keyword
		rst = Geocoder.search(keyword)
		puts rst[0].latitude
		puts rst[0].longitude
		att["lat"] = rst[0].latitude
		att["lng"] = rst[0].longitude
		geo = JSON.parse('{
		  "type": "Feature",
		  "geometry": {
		    "type": "Point",
		    "coordinates": [0,0]
		  },
		  "properties": {
		    "name": ""
		  }
		}')
		geo["geometry"]["coordinates"] = [att["lng"], att["lat"]]
		geo["properties"]["name"] = keyword

		geo_data << geo

		cd = cd + 1
		if cd > 50
			sleep 1
			cd = 0
		end
	end
else
	file = File.read(file_path)
	data = JSON.parse(file)
end

File.open("data/125_attractions_geo.json","w") do |f|
 f.write( JSON.pretty_generate(geo_data) )
end

File.open("data/125_attractions_latlng.json","w") do |f|
 f.write( JSON.pretty_generate(data) )
end

CSV.open("data/125-attractions_latlng.csv", 'w', headers: data.first.keys) do |csv|
	data.each do |h|
		csv << h.values
	end
end

# File.open("data/offcampus_latlng.csv","w") do |f|
# 	for apt in data 
# 		str = apt["name"] + ', "' + apt["address"] +'", '\
# 		+ apt["lat"].to_s + ', ' + apt["lng"].to_s + '\n' 
# 		f.write( str )
# 	end
# end