require 'open-uri'
require 'nokogiri'

Cat = Struct.new(:name, :age, :sn, :breed, :loc, :arrival_date, :image, :url, :id)

def retrieve_cats_url(url)
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

