require 'bundler'
Bundler.require

require_relative '../lib/song'

DB = {:conn => SQLite3::Database.new("db/songs.db")}
DB[:conn].results_as_hash = true 
