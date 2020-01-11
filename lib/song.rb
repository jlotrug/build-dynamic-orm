require 'active_support/inflector'


class Song
  attr_accessor :name, :artist
  attr_reader :id

  def initialize(id = nil, name, artist)
    @name = name
    @artist = artist
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        artist TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE songs
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO songs(name, artist) VALUES (?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.artist)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
  end

  def self.create(name:, artist:)
    song = Song.new(name, artist)
    song.save
    song
  end

  def self.table_name
    self.to_s.downcase.pluralize
  end




end
