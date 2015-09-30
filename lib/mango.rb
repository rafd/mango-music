require_relative 'database'
require_relative 'track'

class Mango

  def initialize(db_file)
    @db = Database.new(db_file)
  end

  def self.track_to_array(track)
    [track.id, track.name, track.artist, track.plays]
  end

  def self.array_to_track(arr)
    Track.new(arr[1],arr[2],arr[3],arr[0])
  end

  def add(name,artist)
    @db.add(Mango.track_to_array(Track.new(name,artist)))
  end

  def all
    @db.all.map {|arr| Mango.array_to_track(arr) }
  end

  def update(track)
    @db.update(Mango.track_to_array(track))
  end

  def find_by_title(title)
    self.all.find do |t|
      t.name == title
    end
  end

  def search(query)
    self.all.select do |track|
      /#{query}/ =~ track.name or /#{query}/ =~ track.artist
    end
  end

end
