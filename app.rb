# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/' do
    return erb(:index)
  end


get '/get-artists' do
  repo = ArtistRepository.new
  listofartists = repo.all
  listofartists.map do |obj| 
    obj.name
  end.join(', ')
end

post '/artists' do
  if params[:name] == nil || params[:genre] == nil 
    status 400
    return "Please fill out the fields"
  end
  name = params[:name]
  genre = params[:genre]
  repo = ArtistRepository.new
  artist = Artist.new
  artist.name = name
  artist.genre = genre
  repo.create(artist)
  check = repo.all
  check.map do |obj|
    obj.name
  end.join(', ')
end


post '/name' do
  @name = params[:name]
  return erb(:index)
end

get '/helloname' do
  @name = params[:name]
  return erb(:index)
end

get '/albums' do
  album_repo = AlbumRepository.new
  @albums = album_repo.all
  return erb(:albums)
end

get '/albums/new' do
  #gets the album page with forms
  return erb(:new_album)
end

post '/albums' do
  #gets posted album values
  if params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil
    status 400
    return ""
  end
  repo = AlbumRepository.new
  album = Album.new
  album.title = params[:title]
  album.release_year = params[:release_year]
  album.artist_id = params[:artist_id]
  repo.create(album)
  return ""
end


get '/albums/:id' do
  id = params[:id]
  album_repo = AlbumRepository.new
  found = album_repo.find(id)
  @albumtitle = found.title
  @albumrelease = found.release_year
  return erb(:albumid)
end

get '/artists/new' do
return erb(:new_artist)
end


get '/artists/:id' do
  id = params[:id]
  repo = ArtistRepository.new
  @result = repo.find(id)
  return erb(:artists)
end

get '/artists' do
  repo = ArtistRepository.new
  @artists = repo.all
  return erb(:artistsid)
end


end

