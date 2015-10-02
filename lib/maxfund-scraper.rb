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
  csv << ["Name", "ID", "Description", "SexSN", "Breed", "Age", "Room", "Image", "URL", "Category"]
  reg_cats.each do |cat|
    csv << ["#{cat.name}", "#{cat.id}", "#{cat.description}", "#{cat.sn}", "#{cat.breed}", "#{cat.age}", "#{cat.loc}", "#{cat.image}", "#{cat.url}", "Regular"]
  end
  sn_cats.each do |cat|
    csv << ["#{cat.name}", "#{cat.id}", "#{cat.description}", "#{cat.sn}", "#{cat.breed}", "#{cat.age}", "#{cat.loc}", "#{cat.image}", "#{cat.url}", "Special Needs"]
  end
end

# add to sqlite with DM
(reg_cats + sn_cats).each do |cat|
  puts "writing #{cat.name} to database."
  begin
    @cat = CatDM.first_or_create({maxfund_id: cat.id}, {
                 maxfund_id: cat.id,
                 name: cat.name,
                 description: cat.description,
                 breed: cat.breed,
                 age: cat.age,
                 sexSN: cat.sn,
                 loc: cat.loc,
                 image_url: cat.image,
                 color: cat.color,
                 url: cat.url,
                 intake_date:  Date.strptime(cat.intake, "%m/%d/%Y").to_time,
              })
    puts "saved #{@cat}, meow mr. #{@cat.name}"
  rescue DataMapper::SaveFailureError => e
    puts e.resource.errors.inspect
  end
end
