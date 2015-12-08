require 'open-uri'
require 'nokogiri'
require 'mechanize'

Cat = Struct.new(:name, :id, :description, :age, :sn, :breed, :loc, :arrival_date, :image, :url, :intake, :color)

def retrieve_cats_url(url)
  agent = Mechanize.new
  cats = []
  iframe = Nokogiri::HTML(open(url))
  list_items = iframe.css("table#tblSearchResults td.list-item")
  puts "found #{list_items.count} cats"
  list_items.each do |cat_td|
  #iframe.css("table#tblSearchResults td.list-item").each do |cat_td|

    next unless cat_td.css(".list-animal-name a").first
    cat = Cat.new
    cat.name = cat_td.css(".list-animal-name a").text
    cat.id = cat_td.css(".list-animal-id").text
    cat.url = "http://www.petango.com/webservices/adoptablesearch/wsAdoptableAnimalDetails.aspx?id=#{cat.id}" 
    cat_page = Nokogiri::HTML(open(cat.url))
    #cat.description = cat_page.css("span#ct100_main_lbDescription")
    cat.description = cat_page.css("div.detail-animal-desc")
    cat.intake = cat_page.css("span#ctl00_main_lblIntakeDate").text
    cat.color = cat_page.css("span#lblColor").text
    cat.image = "http:" + cat_page.css("img#ctl00_main_imgAnimalPhoto").first["src"]
    # save image locally
    img_loc = "image/cat-#{cat.id}.jpg"
    if !File.exists? "public/#{img_loc}"
      agent.get(cat.image).save "public/#{img_loc}"
    end
    cat.image = img_loc
    cat.breed = cat_td.css(".list-animal-breed").text
    cat.age = cat_td.css(".list-animal-age").text
    cat.sn = cat_td.css(".list-animal-sexSN").text
    cat.loc = cat_td.css(".hidden").text
    cats << cat
  end
  cats
end

