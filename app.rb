require 'rubygems'
require 'sinatra'
require './lib/maxfund-dm'

get '/' do
  erb :cats
end

get '/cats' do
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

