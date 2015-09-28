require 'open-uri'
require 'nokogiri'
require 'csv'
require 'data_mapper'
require './lib/maxfund-dm'
require './lib/maxfund-cats'

doc = Nokogiri::HTML(open('http://maxfund.org/adopt-a-cat/'))
url = doc.css('iframe')[0].attributes["src"].text
reg_cats = retrieve_cats_url(url)

doc = Nokogiri::HTML(open('http://maxfund.org/special-cats/'))
url = doc.css('iframe')[0].attributes["src"].text
sn_cats = retrieve_cats_url(url)

CSV.open("cats.csv", "wb") do |csv|
  csv << ["Name", "ID", "SexSN", "Breed", "Age", "Room", "Image", "URL", "Category"]
  reg_cats.each do |cat|
    csv << ["#{cat.name}", "#{cat.id}", "#{cat.sn}", "#{cat.breed}", "#{cat.age}", "#{cat.loc}", "#{cat.image}", "#{cat.url}", "Regular"]
  end
  sn_cats.each do |cat|
    csv << ["#{cat.name}", "#{cat.id}", "#{cat.sn}", "#{cat.breed}", "#{cat.age}", "#{cat.loc}", "#{cat.image}", "#{cat.url}", "Special Needs"]
  end
end


