require 'rubygems'
require 'sinatra'
require './lib/maxfund-dm'

get '/' do
  @cats = CatDM.current
  @cat_alumni = CatDM.alumni
  haml :welcome
end


get '/cat/:id' do
  @cat = CatDM.get(params[:id])
  haml :cat_detail
end

get '/cats.json' do
  content_type :json
  @cats = CatDM.all.to_json
end

get '/cats' do
  erb :cats
end

