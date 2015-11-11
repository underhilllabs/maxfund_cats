require 'open-uri'
require 'nokogiri'
require 'mechanize'

Cat = Struct.new(:name, :id, :description, :age, :sn, :breed, :loc, :arrival_date, :image, :url, :intake, :color)

def retrieve_cats_url(url)
  agent = Mechanize.new
  cats = []
  iframe = Nokogiri::HTML(open(url))
  iframe.css("table#tblSearchResults td.list-item").each do |cat_td|
    next unless cat_td.css(".list-animal-name a").first
    cat = Cat.new
    cat.name = cat_td.css(".list-animal-name a").text
    cat.id = cat_td.css(".list-animal-id").text
    cat.url = "http://www.petango.com/webservices/adoptablesearch/wsAdoptableAnimalDetails.aspx?id=#{cat.id}" 
    cat_page = Nokogiri::HTML(open(cat.url))
    cat.description = cat_page.css("span#lbDescription").text
    cat.intake = cat_page.css("span#lblIntakeDate").text
    cat.color = cat_page.css("span#lblColor").text
    cat.image = "http:" + cat_page.css("img#imgAnimalPhoto").first["src"]
    # save image locally
    img_loc = "image/cat-#{cat.id}.jpg"
    if !File.exists? "public/#{img_loc}"
      agent.get(cat.image).save "public/#{img_loc}"
      puts "saving #{cat.image} to #{img_loc}"
    end
    cat.image = img_loc
    #cat.image = cat_td.css(".list-animal-photo-block img").first["src"]
    cat.breed = cat_td.css(".list-animal-breed").text
    cat.age = cat_td.css(".list-animal-age").text
    cat.sn = cat_td.css(".list-animal-sexSN").text
    cat.loc = cat_td.css(".hidden").text
    cats << cat
  end
  cats
end

