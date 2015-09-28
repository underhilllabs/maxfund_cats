DataMapper.setup(:default, 'sqlite:///maxfund_cats.db')

class Post
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :name,      String    # A varchar type string, for short strings
  property :maxfund_id,      String
  property :breed,      String
  property :age,      String
  property :sexSN,      String
  property :loc,      String
  property :url,      String
  property :image_url,      String
  property :description,       Text      # A text block, for longer string data.
  property :created_at, DateTime  # A DateTime, for any date you might like.
endD

DataMapper.finalize
