require 'open-uri'
require 'nokogiri'
require 'csv'
require 'data_mapper'
require './lib/maxfund-dm'
require './lib/maxfund-cats'

doc = Nokogiri::HTML(open('http://maxfund.org/adopt-a-cat/'))
url = doc.css('iframe')[0].attributes["src"].text
puts "iframe url: #{url}"
reg_cats = retrieve_cats_url(url)

doc = Nokogiri::HTML(open('http://maxfund.org/special-cats/'))
url = doc.css('iframe')[0].attributes["src"].text
puts "iframe url: #{url}"
sn_cats = retrieve_cats_url(url)

# First set is_current to 0 foreach
CatDM.update(:is_current => 0)
# add to sqlite with DM
(reg_cats + sn_cats).each do |cat|
  begin
    @cat = CatDM.first_or_new(maxfund_id: cat.id)
    intake = cat.intake || null
    attr = { maxfund_id: cat.id,
             name: cat.name,
             description: cat.description,
             breed: cat.breed,
             age: cat.age,
             sexSN: cat.sn,
             loc: cat.loc,
             is_current: 1,
             image_url: cat.image,
             color: cat.color,
             url: cat.url,
             intake_date:  Date.strptime(intake, "%m/%d/%Y").to_time,
    }
    @cat.attributes = attr
    @cat.save
  rescue DataMapper::SaveFailureError => e
    puts e.resource.errors.inspect
  end
end
