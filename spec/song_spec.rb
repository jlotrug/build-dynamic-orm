require "spec_helper"
require 'pry'
#require_relative "../config/environment.rb"


describe "Song" do
  let(:longview) {Song.new("Longview", "Green Day")}

  before(:each) do
    DB[:conn].execute("DROP TABLE IF EXISTS songs")
  end

  describe "When initialized with a name and artist" do
    it 'the artist attribute can be accessed' do
      song = Song.new("DumpWeed", "Blink 182")
      expect(song.artist).to eq("Blink 182")
    end

    it "name attribute can be accessed" do
      song = Song.new("Green Day", "American Idiot")
      expect(song.artist).to eq("American Idiot")
    end
  end

  it "responds to a getter for :id" do
    expect(longview).to respond_to(:id)
  end

  it "does not provide a setter for :id" do
    expect{longview.id = 1}.to raise_error(NoMethodError)
  end

  describe ".create_table" do
    it 'creates table for songs' do
      Song.create_table
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='songs';"
      expect(DB[:conn].execute(table_check_sql)[0]['tbl_name']).to eql('songs')
    end
  end

    describe ".drop_table" do
      it 'drops table for songs' do
        Song.create_table
        Song.drop_table

      sql = "SELECT tbl_name FROM sqlite_master WHERE type = 'table' AND tbl_name = 'songs';"
      expect(DB[:conn].execute(sql)[0]).to eq(nil)
    end
  end

  describe "#save" do
    it 'saves an instance of song class to the database' do
      Song.create_table
      longview.save
      expect(longview.id).to eq(1)
        #binding.pry
      expect(DB[:conn].execute("SELECT * FROM songs")[0]['name']).to eq("Longview")
      expect(DB[:conn].execute("SELECT * FROM songs")[0]['artist']).to eq("Green Day")
      expect(DB[:conn].execute("SELECT * FROM songs")[0]['id']).to eq(1)
    end       #expect(DB[:conn].execute("SELECT * FROM songs").has_key?("name")).to eq([{'id' => 1 ,'name'=> "Longview", 'artist'=> "Green Day"}])

  end

  describe ".create" do
    before(:each) do
      Song.create_table
    end
    it 'takes a hash of attributes and creates new song object, uses save to save it to song table' do
      Song.create(name: "Dumpweed", artist: "Blink 182")
      #binding.pry
      expect(DB[:conn].execute("SELECT * FROM songs")[0]['id']).to eq(1)
      expect(DB[:conn].execute("SELECT * FROM songs")[0]['name']).to eq('Dumpweed')
      expect(DB[:conn].execute("SELECT * FROM songs")[0]['artist']).to eq("Blink 182")
    end
    it 'returns the new object' do
      song = Song.create(name: "Hey Jude", artist: "Beatles")
      expect(song).to be_a(Song)
      expect(song.artist).to eq("Beatles")
      expect(song.name).to eq("Hey Jude")
      expect(song.id).to eq(1)
    end
  end

  describe ".table_name" do
    it "returns the table name" do
      table = Song.table_name
      expect(table).to eq("songs")
    end
  end
end
