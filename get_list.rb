# encoding=utf-8 
require "open-uri"
require "json"


n_pages = 7

top_url = "http://www.listchallenges.com/top-250-famous-attractions-in-the-world/checklist/"

pat1 = /<div class="item-name">\s+(.+)\s+<\/div>/



top = open(top_url).read
urls = top.scan(pat1).to_a

data = []

for t in 1..n_pages

	new_url = top_url + t.to_s


	page = open(new_url).read
	sub_list = page.scan(pat1).to_a

	puts sub_list

	for att in sub_list
		
		item = {}
		item["name"] = att[0][0..(att[0].size-2)].gsub('\r', '')
		data << item
	end
end

File.open("data/125-attractions.json","w") do |f|
 f.write( JSON.pretty_generate(data) )
end