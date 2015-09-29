require 'rubygems'
require 'sinatra'
require './lib/maxfund-dm'

get '/' do
  @cats = CatDM.all
  haml :welcome
end

get '/cat/:id' do
  @cat = CatDM.get(params[:id])
  haml :cat_detail
end
