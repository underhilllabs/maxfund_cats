require 'open-uri'
require 'nokogiri'
require 'csv'

class Cat
  attr_accessor :name, :age, :sn, :breed, :loc, :arrival_date, :image, :url, :id
end

def retrieve_cats(url)
  cats = []
  iframe = Nokogiri::HTML(open(url))
  iframe.css("table#tblSearchResults td.list-item").each do |cat_td|
    next unless cat_td.css(".list-animal-name a").first
    cat = Cat.new
    cat.name = cat_td.css(".list-animal-name a").text
    cat.url = cat_td.css(".list-animal-name a").first["href"]
    cat.image = cat_td.css(".list-animal-photo-block img").first["src"]
    cat.breed = cat_td.css(".list-animal-breed").text
    cat.id = cat_td.css(".list-animal-id").text
    cat.age = cat_td.css(".list-animal-age").text
    cat.sn = cat_td.css(".list-animal-sexSN").text
    cat.loc = cat_td.css(".hidden").text
    cats << cat
  end
  cats
end

doc = Nokogiri::HTML(open('http://maxfund.org/adopt-a-cat/'))
url = doc.css('iframe')[0].attributes["src"].text
reg_cats = retrieve_cats(url)

doc = Nokogiri::HTML(open('http://maxfund.org/special-cats/'))
url = doc.css('iframe')[0].attributes["src"].text
sn_cats = retrieve_cats(url)

CSV.open("cats.csv", "wb") do |csv|
  csv << ["Name", "SexSN", "Breed", "Age", "Room", "Image", "URL", "Category"]
  reg_cats.each do |cat|
    csv << ["#{cat.name}", "#{cat.sn}", "#{cat.breed}", "#{cat.age}", "#{cat.loc}", "#{cat.image}", "#{cat.url}", "Regular"]
  end
  sn_cats.each do |cat|
    csv << ["#{cat.name}", "#{cat.sn}", "#{cat.breed}", "#{cat.age}", "#{cat.loc}", "#{cat.image}", "#{cat.url}", "Special Needs"]
  end
end


