require 'csv'

class Database
  def initialize(db_file)
    @db_file = db_file
  end

  def count
    CSV.read(@db_file).length
  end

  def add(data)
    CSV.open(@db_file,"ab") do |csv|
      data[0] = $. # $. is current line number
      csv << data
    end
  end

  def all
    CSV.read(@db_file)
  end

  def replace(data)
    CSV.open(@db_file, "wb") do |csv|
      data.each do |t|
        csv << t
      end
    end
  end

  def update(arr)
    # TODO: can make more efficient
    id = arr[0]
    records = self.all
    records[id] = arr
    self.replace(records)
  end
end

class Track
  attr_reader :id, :name, :artist, :plays

  def initialize(name, artist, plays=0, id=nil)
    @id = id.to_i
    @name = name
    @artist = artist
    @plays = plays.to_i
  end

  def listen
    @plays+=1
  end
end

class Mango

  def initialize(db)
    @db = db
  end

  def self.track_to_array(track)
    [track.id, track.name, track.artist, track.plays]
  end

  def self.array_to_track(arr)
    Track.new(arr[1],arr[2],arr[3],arr[0])
  end

  def add(track)
    @db.add(Mango.track_to_array(track))
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

end

def run(output, input_stream, db_file)
  output.puts "Welcome to Mango Music"
  output.puts "You can:"
  output.puts "add <track> <artist>"
  output.puts "listen <id of track>"
  output.puts "list"
  output.puts "search <search term>"
  output.puts "quit"
  output.puts ""
  output.puts "What do now?"
  input = input_stream.gets.chomp
  db = Database.new(db_file)
  mango = Mango.new(db)

  while input != "exit"
    case input.split(" ")[0]
    when "add"
      _, name, artist = input.split(" ")
      mango.add(Track.new(name,artist))
      output.puts "saved!"
    when "listen"
      title = input.split(" ")[1]
      track = mango.find_by_title(title)
      if track
        output.puts "You're listening to... #{track.name} by #{track.artist}"
        track.listen
        mango.update(track)
      end
    when "list"
      tracks = db.all.map {|arr| Mango.array_to_track(arr) }
      tracks.each do |t|
        output.puts "#{t.id}: #{t.name} by #{t.artist} (#{t.plays} listens)"
      end
    when "search"
      tracks = db.all.map {|arr| Mango.array_to_track(arr) }
      query = input.split(" ")[1]

      tracks.select do |track|
        /#{query}/ =~ track.name or /#{query}/ =~ track.artist
      end
      tracks.each do |t|
        output.puts "#{t.id}: #{t.name} by #{t.artist} (#{t.plays} listens)"
      end
    else
      output.puts "Huh?"
    end

    output.puts ""
    output.puts "What do now?"
    input = input_stream.gets.chomp
  end

  output.puts ""
  output.puts "Bye bye!"

end
