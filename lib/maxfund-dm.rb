require 'data_mapper'
DataMapper.setup(:default, 'sqlite:data/maxfund_cats.db')

class CatDM
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :name,      String    # A varchar type string, for short strings
  property :maxfund_id,      String
  property :breed,      String
  property :age,      String
  property :color, String
  property :is_current, Integer
  property :sexSN,      String
  property :loc,      String
  property :url,      Text
  property :image_url,      Text
  property :description,       Text      # A text block, for longer string data.
  property :intake_date, DateTime
  property :created_at, DateTime  # A DateTime, for any date you might like.
  property :updated_at, DateTime

  def self.current
    all(is_current: 1, order: [:loc.asc, :intake.desc])
  end
  
  def self.alumni
    all(is_current: 0, order: [:loc.asc, :intake.desc])
  end

  before :save do
    self.updated_at = Time.now
  end

  before :create do
    self.created_at = Time.now
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!
DataMapper::Model.raise_on_save_failure = true 
