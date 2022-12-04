require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "get /" do
    it "returns html index" do
    response = get('/')
    expect(response.body).to include('<h1>Welcome to my page</h1>')
end
end

context "get /get-artists" do
  it "tests the /get-artists path" do
  response = get('/get-artists')
  expect(response.status).to eq 200
  expect(response.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone"
  end
end
context "post /artists" do
  it "adds an artist to the album" do
    response = post('/artists?name=Wild nothing&genre=Indie')
    expect(response.status).to eq 200
    expect(response.body).to eq 'Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing'
  end
end
context "returns name " do
  it "returns a name" do
  response = post('/name?name=John')
  expect(response.body).to include ('John')
end
end
context "get /name" do
  it "returns a html message with a given name" do
    response = get('/helloname', name: 'Meep')
    expect(response.body).to include ("Hello Meep")
  end
end

context 'get /albums' do
  it "lists and returns the albums in html" do
  response = get('/albums') 
    expect(response.body).to include ('Waterloo')
    expect(response.body).to include ('Surfer Rosa')
    #expect(response.body).to include ('Release year: 1974')
    #expect(response.body).to include ('Release year: 1988')
end
end
context 'GET /albums/:id' do
  it "gets album at id 2" do
    response = get('/albums/2')
    expect(response.status).to eq 200
    expect(response.body).to include "Surfer Rosa"
    expect(response.body).to include "1988"
  end
end
context " get /album -> album/:id" do
  it "finds a link to album id from the get albums request" do
    response = get("/albums") 
    expect(response.status).to eq 200
    expect(response.body).to include("<a href='/albums/2'>Surfer Rosa</a>")
    expect(response.body).to include("<a href='/albums/3'>Waterloo</a>")
    expect(response.body).to include("<a href='/albums/4'>Super Trouper</a>")

end
end




context "GET /artists/:id" do
  it "gets information for a single artist" do
    response = get('/artists/1')
    expect(response.body).to include('Pixies')
  end
  it "gets information for a single artist" do
    response = get('/artists/2')
    expect(response.body).to include('ABBA')
  end
end


context "GET /artists" do
  it 'returns a html page with lists of artists with links to their artist page' do
    response = get('/artists')
    expect(response.body).to include("<a href='/artists/2'>ABBA</a>")
  end
end


context "GET /albums/new" do
  it "returns form to add a new album" do
    response = get('/albums/new')
    expect(response.status).to eq 200
    expect(response.body).to include("<form method='POST' action='/albums'>")

  end
  end

  context "POST /albums" do
    it "creates a new artist" do
      response = post('/albums', title:"Meteora", release_year:'2000',artist_id:'1')
      expect(response.status).to eq 200
      expect(response.body).to eq ""
      #check that it has been added to the GET request albums list
      response2 = get('/albums')
      expect(response2.body).to include ("Meteora")
    end
    it "stops the programming if an error/nil values obtained" do
      response = post('/albums', title:'invalid', release_year: nil)
      expect(response.status).to eq 400
      expect(response.body).to eq ""
  end
end

  context "GET /artists/new" do
    it "returns a form to create a new artist" do
      response = get("/artists/new")
      expect(response.status).to eq 200
      expect(response.body).to include "<form method='POST' action='/artists'>"
end
end
    context "POST /artists" do
      it "creates a new artist and adds to artist table, returning the artist table" do
        response = post('/artists', name:"Steve", genre:"Rap")
        expect(response.status).to eq 200
        expect(response.body).to include ("Steve")
      end
      it "doesn't create a new artist if no values given" do
        response = post('/artists', name:' ',)
        expect(response.status).to eq 400
        expect(response.body).to include ("Please fill out the fields")
    end
  end



end