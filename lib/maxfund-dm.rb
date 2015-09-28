require 'data_mapper'
DataMapper.setup(:default, 'sqlite:data/maxfund_cats.db')

class CatDM
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :name,      String    # A varchar type string, for short strings
  property :maxfund_id,      String
  property :breed,      String
  property :age,      String
  property :sexSN,      String
  property :loc,      String
  property :url,      Text
  property :image_url,      Text
  property :description,       Text      # A text block, for longer string data.
  property :created_at, DateTime  # A DateTime, for any date you might like.
  property :updated_at, DateTime
end

DataMapper.auto_migrate!
DataMapper::Model.raise_on_save_failure = true 
